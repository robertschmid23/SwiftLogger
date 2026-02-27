//
//  TimeFormats.swift
//  SwiftLogger
//
//  Created by Robert Schmid on 10/2/2025.
//

import class Foundation.DateFormatter
import struct Foundation.TimeZone
import struct Foundation.Date

final class Formatters
{
	private let timeWithHours = DateFormatter()
	private let shortTime = DateFormatter()
	private let logFormat = DateFormatter()
	
	init()
	{
		timeWithHours.timeZone = TimeZone(secondsFromGMT: 0)
		timeWithHours.dateFormat = "HH:mm:ss.SSS"
		shortTime.timeZone = TimeZone(secondsFromGMT: 0)
		shortTime.dateFormat = "mm:ss.SSS"

		logFormat.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS zzz"
	}
	
	func from(date: Date) -> String
	{
		if date.timeIntervalSinceReferenceDate < 3600
		{
			return shortTime.string(from: date)
		}
		return timeWithHours.string(from: date)
	}
	
	func logTime() -> String
	{
		return logFormat.string(from: Date())
	}
}
