//
//  LogConfig.swift
//  SwiftLogger
//
//  Created by Robert Schmid on 10/2/2025.
//

import Foundation

struct LogConfig: Codable, Equatable
{
	let levels: [String]
	let ttyRoot: String? // a path to a file that will contain the logging output
		
	init(threshhold: Threshold, sessionLogging: Bool, timeLogging: Bool,
		 notificationLogging: Bool, ttyRoot: String? = nil)
	{
		var lvls: [Threshold] = [threshhold]
		if threshhold.rawValue <= Threshold.ERROR.rawValue
		{
			if timeLogging
			{
				lvls.append(.TIME)
			}
			if sessionLogging
			{
				lvls.append(.SESSION)
			}
			if notificationLogging
			{
				lvls.append(.NOTIFICATIONS)
			}
		}
		self.levels = lvls.map {$0.name.first ?? "UNDEFINED"}
		self.ttyRoot = ttyRoot
	}
}
