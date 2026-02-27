//
//  Log.swift
//  SwiftLogger
//
//  Created by Robert Schmid on 10/2/2025.
//
import Foundation

//@GlobalLogActor
public class Log //: Sendable
{
	nonisolated(unsafe) private static let shared = SwiftLogger()
	nonisolated(unsafe) private static var loggers: [String: SwiftLogger] = [:]
    
    static func logger(subsystem: String? = nil, category: String? = nil) -> SwiftLogger
    {
        if subsystem == nil && category == nil
        {
            return shared
        }
        let loggerId = "\(subsystem ?? "")_\(category ?? "")"
        if let logger = loggers[loggerId]
        {
            return logger
        }
        else
        {
            let newLogger = SwiftLogger(subsystem: subsystem, category: category)
            loggers[loggerId] = newLogger
            return newLogger
        }
    }
    
    //static funcs are concurrency safe
    public static func debug(_ format:String, subsystem: String? = nil, category: String? = nil, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
    {
        logger(subsystem: subsystem, category: category).debug(format, file: file, funcName: funcName, line: line, args: args)
    }
    
    public static func info(_ format:String, subsystem: String? = nil, category: String? = nil, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
    {
        logger(subsystem: subsystem, category: category).info(format, file: file, funcName: funcName, line: line, args: args)
    }
    
    public static func warn(_ format:String, subsystem: String? = nil, category: String? = nil, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
    {
        logger(subsystem: subsystem, category: category).warn(format, file: file, funcName: funcName, line: line, args: args)
    }
    
    public static func error(_ format:String, subsystem: String? = nil, category: String? = nil, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
    {
        logger(subsystem: subsystem, category: category).error(format, file: file, funcName: funcName, line: line, args: args)
    }
    
    public static func reloadFromUserDefaults()
    {
        do
        {
            try shared.reloadFromUserDefaults()
        }
        catch
        {
            print ("Error reloading Log from UserDefaults: \(error)")
        }
    }
}
