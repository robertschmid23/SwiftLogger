//
//  JSONLogger.swift
//
//
//  Created by Robert Schmid on 12/2/2025.
//

import Foundation

extension SwiftLogger
{
	@objc public func debugJSONObjc(json: Data?)
	{
		if let data = json, let raw = String(data: data, encoding: String.Encoding.utf8)
		{
			fLog(file: "", funcName: "", line: 0, level: .DEBUG, format: raw, args: [] as [String])
		}
	}
	
	public func debugJson(json: Data?, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
	{
		if let data = json, let raw = String(data: data, encoding: String.Encoding.utf8)
		{
			fLog(file: file, funcName: funcName, line: line, level: .DEBUG, format: raw, args: args)
		}
	}
	
	public func errorJson(json: Data?, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
	{
		if let data = json, let raw = String(data: data, encoding: String.Encoding.utf8)
		{
			fLog(file: file, funcName: funcName, line: line, level: .ERROR, format: raw, args: args)
		}
	}
	
	public func prettyPrint(codable: Codable, name: String, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
	{
		let encoder = JSONEncoder()
		encoder.outputFormatting = [.prettyPrinted]
		if let json = try? encoder.encode(codable), let jStr = String(data: json, encoding: .utf8)
		{
			let raw = "\(name): \(jStr)"
			fLog(file: file, funcName: funcName, line: line, level: .ERROR, format: raw, args: args)
		}
	}
}
