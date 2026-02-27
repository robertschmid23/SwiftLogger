//
//  StopWatchLogger.swift
//
//  Created by Robert Schmid on 10/2/2025.
//
import Foundation

extension SwiftLogger
{
	private func addTimerMark(key: TimerKey)
	{
		self.timerMap.add(key: key, date: Date())
	}
	
	private func removeTimerMark(forKey: TimerKey) -> Date?
	{
		return customQueue.sync(flags: .barrier) {
			return self.timerMap.remove(key: forKey)
		}
	}
	
	public func markTimerStart(file: String = #file, funcName: String = #function, line: Int = #line, blockId: String = "", msg: String = "")
	{
		addTimerMark(key: TimerKey(file: file, funcName: funcName, line: line, blockId: blockId))
		fLog(file: file, funcName: funcName, line: line, level: .TIME, format: "\(msg)", args: [] as [String])
	}
	
	public func markTime(file: String = #file, funcName: String = #function, line: Int = #line, blockId: String = "", msg: String)
	{
		let end = Date()
		if let newKey = startKey(file: file, funcName: funcName, line: line, blockId: blockId),
			let start = self.timerMap.date(forKey: newKey)
		{
			let duration = end.timeIntervalSince(start)
			let durStr = timeString.duration(from: duration)
			let dateStr:String = timeFormats.from(date: end)
			
			fLog(file: file, funcName: funcName, line: line, level: .TIME, format: "\(msg) at \(dateStr) (\(durStr))", args: [] as [String])
		}
	}
	
	public func markTimerEnd(file: String = #file, funcName: String = #function, line: Int = #line, blockId: String = "", msg: String)
	{
		let end = Date()
		if let newKey = startKey(file: file, funcName: funcName, line: line, blockId: blockId),
		   let start = removeTimerMark(forKey: newKey)
		{
			let duration = end.timeIntervalSince(start)
			let durStr = timeString.duration(from: duration)
			let dateStr:String = timeFormats.from(date: end)
			
			fLog(file: file, funcName: funcName, line: line, level: .TIME, format: "\(msg) at \(dateStr) (\(durStr))", args: [] as [String])
		}
	}
	
	private func startKey(file: String, funcName: String, line: Int, blockId: String) -> TimerKey?
	{
		let newKey = TimerKey(file: file, funcName: funcName, line: line, blockId: blockId)
		let possibleKeys = timerMap.keys(matching: newKey)

		if var closestKey = possibleKeys.first
		{
			if possibleKeys.count > 1
			{
				possibleKeys.forEach { key in
					if key != closestKey && key.line > closestKey.line
					{
						closestKey = key
					}
				}
			}
			return closestKey
		}
		return nil
	}
}
