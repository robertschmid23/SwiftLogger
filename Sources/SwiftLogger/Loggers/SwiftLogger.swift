//
//  SwiftLogger.swift
//  SwiftLogger
//
//  Created by Robert Schmid on 10/2/2025.
//

import Foundation
import OSLog

let SwiftLoggerIdentifier = "SwiftLogger"
/**
* Helper methods that make logging more consistent throughout the app.  These methods also allow for indentation making
* the logs easier to read when processing a lot of data.  The log calls in ecgmagic are not really intended for external
* use.  These will simply be silent in the absence of an available logging system like CocoaLumberjack or SwiftLogger
*
* 2023-08-12: Remove Swift OS Logger.  Use Stdout directly so as to have better control when not running inside XCode.
*/

class SwiftLogger
{
	private let dateFormatter = DateFormatter()
	let timeFormats = Formatters()

	//Bundle.main.url is for Apps
	//Bundle.module is for Swift Packages
	private let package = Bundle.main.bundleIdentifier ?? Bundle.module.bundleIdentifier ?? "net.raptor.SwiftLogger"
	private var userDefaults: UserDefaults
	
	//This was added after os.Logger so it stays
	let customQueue = DispatchQueue(label: "net.raptor.Log.queue",
											qos: .default, attributes: .concurrent)
	let levelMap: ThresholdMap = ThresholdMap()
	
	public var useIndenting = true
	
	private let TAB = "\t"

	var threshold = Threshold.OFF
	var logger: Logger  //OSLog.Logger

	var timeString: TimeString { TimeString() }
	let timerMap: TimerMap = TimerMap()

	public init(subsystem: String? = nil, category: String? = nil)
	{
		let suiteName = package + ".SwiftLogger"
		self.userDefaults = UserDefaults(suiteName: suiteName) ?? UserDefaults.standard
		let category = category ?? suiteName.components(separatedBy: ".").last ?? "SwiftLogger"
		let subsystem = subsystem ?? package
		self.logger = Logger(subsystem: subsystem, category: category)

		if let logConfig = userDefaults.object(forKey: SwiftLoggerIdentifier) as? Data
		{
			configure(logConfig: logConfig)
		}
		else if let configURL = Bundle.main.url(forResource: SwiftLoggerIdentifier, withExtension: "config")
								?? Bundle.module.url(forResource: SwiftLoggerIdentifier, withExtension: "config")
		{
			do {
				let data = try Data(contentsOf: configURL, options: .mappedIfSafe)
				configure(logConfig: data)
			} catch {
				print("Unable to intialize SwiftLogger: \(error)")
			}
		}
	}
	
	private func configure(logConfig: Data)
	{
		do
		{
			let logDefaults: LogConfig = try JSONDecoder().decode(LogConfig.self, from: logConfig)
			threshold = Threshold(levels: logDefaults.levels)
			
			//THIS CAN ONLY BE ENABLED while the app is running in a simulator
			#if targetEnvironment(simulator)  //USE THIS INSTEAD OF DEBUG
			enableTTYLogfile(logDefaults.ttyRoot)
			#endif
		}
		catch
		{
			print("Unable to intialize SwiftLogger: \(error)")
		}
	}

	func reloadFromUserDefaults() throws
	{
		if let logConfig = userDefaults.object(forKey: SwiftLoggerIdentifier) as? Data
		{
			let logDefaults: LogConfig = try JSONDecoder().decode(LogConfig.self, from: logConfig)
			threshold = Threshold(levels: logDefaults.levels)
			
			//THIS CAN ONLY BE ENABLED while the app is running in a simulator
			#if targetEnvironment(simulator)  //USE THIS INSTEAD OF DEBUG
			enableTTYLogfile(logDefaults.ttyRoot)
			#endif
		}
	}
	
	#if targetEnvironment(simulator)  //USE THIS INSTEAD OF DEBUG
	fileprivate func enableTTYLogfile(_ ttyRoot: String?)
	{
		if let logFile = ttyRoot
		{
			setTTYLogFile( STDOUT_FILENO, logRoot: logFile, suffix: "_out")
			setTTYLogFile( STDERR_FILENO, logRoot: logFile, suffix: "_err")
		}
	}
	
	//If the TTYLogFile is set and necessary, it may be necessary to access it via
	//  FileHandle.standardOutput.write(logData)
	//OSLog now handles that naturally
	fileprivate func setTTYLogFile(_ std: Int32, logRoot: String, suffix: String)
	{
		//isatty() IF the app is NOT launched from XCode. i.e. "is a TTY terminal"
		if isatty(std) <= 0
		{
			let stdLog = logRoot.appending("\(suffix).log")
			if !FileManager.default.fileExists(atPath: stdLog)
			{
				FileManager.default.createFile(atPath: stdLog, contents: nil)
			}
			let dest = std == STDOUT_FILENO ? stdout : stderr
			//This protects against poorly defined backup config
			if FileManager.default.isWritableFile(atPath: stdLog)
			{
				freopen(stdLog, "w", dest) // or stdout
			}
		}
	}
	#endif


	/**
	logs a debug level statement
	
	-Parameters:
	- from: The object calling the logger (usually just 'self')
	- indent: whether or not to use the internal indentation level. (Useful for highlighting some debugging)
	- format: A string with formatting elements
	- args: The arguments that apply to the format String
	*/
	public func debug(_ format:String, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
	{
		fLog(file: file, funcName: funcName, line: line, level: .DEBUG, format: format, args: args)
	}
	
	public func info(_ format:String, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
	{
		fLog(file: file, funcName: funcName, line: line, level: .INFO, format: format, args: args)
	}
	
	public func warn(_ format:String, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
	{
		fLog(file: file, funcName: funcName, line: line, level: .WARN, format: format, args: args)
	}
	
	public func error(_ format:String, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
	{
		fLog(file: file, funcName: funcName, line: line, level: .ERROR, format: format, args: args)
	}
	
	func fLog(file: String, funcName: String, line: Int, level: Threshold, format:String, args:CVarArg)
	{
		var indentCount: Int = -1
		
		if useIndenting
		{
			if let idx = levelMap.index(file: file, funcName: funcName) //.levels.firstIndex(where: {$0 == (file, funcName)})
			{
				indentCount = idx
			}
			else
			{
				levelMap.add(file: file, funcName: funcName)
				//TODO: Make this array decrease again
				indentCount = levelMap.count - 1
			}
		}
		else
		{
			indentCount = 0
		}

		if level.meets(threshold: threshold)
        {
            let fileName = file.components(separatedBy: "/").last!
            let indent = String(repeating: TAB, count: indentCount)
            let msg = "\(timeFormats.logTime()) \(indent)\(format) (\(fileName):\(line))\n"
            
//If we are using XLogger this is not necessary as XLogger logs to stdout.
// but if we are using print or something else, we may need this
//#if targetEnvironment(simulator)
//			if let logData = msg.data(using: .utf8)
//			{
//				FileHandle.standardOutput.write(logData)
//			}
//#endif

			switch level
			{
			case .DEBUG:
				logger.debug("\(msg)")
			case .INFO:
				logger.info("\(msg)")
			case .WARN:
				logger.error("\(msg)")
			case .ERROR:
				logger.fault("\(msg)")
			default:
				logger.notice("\(msg)")
			}
		}
	}
}
