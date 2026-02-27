//
//  LogExtensions.swift
//  SwiftLogger
//
//  Created by Robert Schmid  on 12/3/25.
//

import Foundation

extension Log
{
    public static func debugJson(json: Data?, subsystem: String? = nil, category: String? = nil, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
    {
        logger(subsystem: subsystem, category: category).debugJson(json: json, file: file, funcName: funcName, line: line, args: args)
    }
    
    public static func errorJson(json: Data?, subsystem: String? = nil, category: String? = nil, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
    {
        logger(subsystem: subsystem, category: category).errorJson(json: json, file: file, funcName: funcName, line: line, args: args)
    }
    
    public static func session(request: URLRequest, subsystem: String? = nil, category: String? = nil, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
    {
        logger(subsystem: subsystem, category: category).session(request: request, file: file, funcName: funcName, line: line, args: args)
    }
    
    public static func session(response: URLResponse?, request: URLRequest? = nil,
                        data: Data?, error: Error? = nil,
                        subsystem: String? = nil, category: String? = nil,
                        file: String = #file, funcName: String = #function,
                        line: Int = #line, args:CVarArg = [] as [String])
    {
        logger(subsystem: subsystem, category: category).session(response: response, request: request, data: data, error: error, file: file, funcName: funcName, line: line, args: args)
    }
    
    public static func posted(_ notification: Notification, subsystem: String? = nil, category: String? = nil, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
    {
        logger(subsystem: subsystem, category: category).posted(notification, file: file, funcName: funcName, line: line, args: args)
    }
    
    public static func posted(_ name: Notification.Name, subsystem: String? = nil, category: String? = nil, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
    {
        logger(subsystem: subsystem, category: category).posted(name, file: file, funcName: funcName, line: line, args: args)
    }
    
    public static func received(_ notification: Notification, subsystem: String? = nil, category: String? = nil, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
    {
        logger(subsystem: subsystem, category: category).received(notification, file: file, funcName: funcName, line: line, args: args)
    }
    
    public static func markTimerStart(subsystem: String? = nil, category: String? = nil, file: String = #file, funcName: String = #function, line: Int = #line, blockId: String = "", msg: String = "")
    {
        logger(subsystem: subsystem, category: category).markTimerStart(file: file, funcName: funcName, line: line, blockId: blockId, msg: msg)
    }
    
    public static func markTime(subsystem: String? = nil, category: String? = nil, file: String = #file, funcName: String = #function, line: Int = #line, blockId: String = "", msg: String)
    {
        logger(subsystem: subsystem, category: category).markTime(file: file, funcName: funcName, line: line, blockId: blockId, msg: msg)
    }
    
    public static func markTimerEnd(subsystem: String? = nil, category: String? = nil, file: String = #file, funcName: String = #function, line: Int = #line, blockId: String = "", msg: String)
    {
        logger(subsystem: subsystem, category: category).markTimerEnd(file: file, funcName: funcName, line: line, blockId: blockId, msg: msg)
    }
}
