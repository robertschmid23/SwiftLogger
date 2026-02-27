//
//  HttpLogger.swift
//
//  Created by Robert Schmid on 10/2/2025.
//

import Foundation

extension SwiftLogger
{
	private static let block = "\u{2588}"
	private static let bar = String(repeating: block, count: 24)
	
	public func session(request: URLRequest, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [] as [String])
	{
		if Threshold.SESSION.meets(threshold: threshold)
		{
			var reqLog = "\n\n    BEGIN HTTP REQUEST \(SwiftLogger.bar)\n"
			reqLog.append("        \(request.httpMethod!): \(request.url!)\n")
			for header in request.allHTTPHeaderFields!
			{
				reqLog.append("            \(header.key): \(header.value)\n")
			}
			if let body = request.httpBody, let raw = String(data: body, encoding: String.Encoding.utf8)
			{
				reqLog.append("            \(raw)\n")
			}
			reqLog.append("    END HTTP REQUEST \(SwiftLogger.bar)\n\n")
			fLog(file: file, funcName: funcName, line: line, level: .SESSION, format: reqLog, args: args)
		}
	}
	
	public func session(response: URLResponse?, request: URLRequest? = nil,
						data: Data?, error: Error? = nil,
						file: String = #file, funcName: String = #function,
						line: Int = #line, args:CVarArg = [] as [String])
	{
		if Threshold.SESSION.meets(threshold: threshold), let resp = response as? HTTPURLResponse
		{
			var respLog = "\n\n    BEGIN HTTP RESPONSE \(SwiftLogger.bar)\n"
			if let req = request, let url = req.url
			{
				respLog.append("            Request Path: \(url)\n")
			}
			respLog.append("            Status Code: \(resp.statusCode)\n")

			for header in resp.allHeaderFields
			{
				respLog.append("            \(header.key): \(header.value)\n")
			}
			if let d = data, let raw = String(data: d, encoding: String.Encoding.utf8)
			{
				respLog.append("            \(raw)\n")
			}
			respLog.append("    END HTTP RESPONSE \(SwiftLogger.bar)\n\n")
			fLog(file: file, funcName: funcName, line: line, level: .SESSION, format: respLog, args: args)
		}
	}


}
