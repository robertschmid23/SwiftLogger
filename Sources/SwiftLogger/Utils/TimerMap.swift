//
//  TimerMap.swift
//  SwiftLogger
//
//  Created by Robert Schmid on 10/2/2025.
//

import Foundation

class TimerMap
{
	private var timerMap: [TimerKey: Date] = [:]
	
	func add(key: TimerKey, date: Date)
	{
		self.timerMap[key] = date
	}
	
	func date(forKey key: TimerKey) -> Date?
	{
		return self.timerMap[key]
	}
	
	func remove(key: TimerKey) -> Date?
	{
		return self.timerMap.removeValue(forKey: key)
	}
	
	func keys(matching: TimerKey) -> [TimerKey]
	{
		return timerMap.keys.filter { $0.candidateMatch(newKey: matching) }
	}
}
