//
//  NotificationLogger.swift
//
//  Created by Robert Schmid on 10/2/2025.
//

import Foundation

extension SwiftLogger
{
	public func posted(_ notification: Notification, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
	{
		posted(notification.name, file: file, funcName: funcName, line: line, args: args)
	}
	
	public func posted(_ name: Notification.Name, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
	{
		if Threshold.NOTIFICATIONS.meets(threshold: threshold)
		{
			fLog(file: file, funcName: funcName, line: line, level: .DEBUG, format: "Notification Posted: \(name.rawValue)", args: args)
		}
	}
	
	public func received(_ notification: Notification, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
	{
		if Threshold.NOTIFICATIONS.meets(threshold: threshold)
		{
			fLog(file: file, funcName: funcName, line: line, level: .DEBUG, format: "Notification Received: \(notification.name.rawValue)", args: args)
		}
	}
}
