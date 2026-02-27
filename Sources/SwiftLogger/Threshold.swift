//
//  Threshold.swift
//  
//
//  Created by Robert Schmid on 10/2/2025.
//

import Foundation

public struct Threshold: OptionSet, Hashable, Sendable
{
	public let rawValue: UInt8
	public let name: [String]
	
	public static let OFF = Threshold(rawValue: 1 << 7, name: "OFF")
	public static let NOTIFICATIONS = Threshold(rawValue: 1 << 6, name: "NOTIFICATIONS")
	public static let TIME = Threshold(rawValue: 1 << 5, name: "TIME")
	public static let SESSION = Threshold(rawValue: 1 << 4, name: "SESSION")
	
	public static let ERROR = Threshold(rawValue: 1 << 3, name: "ERROR")
	public static let WARN = Threshold(rawValue: 1 << 2, name: "WARN")
	public static let INFO = Threshold(rawValue: 1 << 1, name: "INFO")
	public static let DEBUG = Threshold(rawValue: 1, name: "DEBUG")
	
	public init(rawValue: UInt8, name: String) {
		self.rawValue = rawValue
		self.name = [name]
	}
	
	public init(rawValue: UInt8) {
		self.rawValue = rawValue
		self.name = ["UNDEFINED"]
	}

	init(levels: [String])
	{
		var raw: UInt8 = levels.count > 0 ? 0 : Threshold.OFF.rawValue
		var lvlNames: [String] = []
		for lStr in levels
		{
			if let l = levelMap[lStr.uppercased()]
			{
				raw = raw | l.rawValue
				lvlNames.append(lStr.uppercased())
			}
		}
		rawValue = raw
		name = lvlNames
	}
	
	func meets(threshold: Threshold) -> Bool
	{
		return threshold != Threshold.OFF &&
			(threshold.contains(self) || meets(degree: threshold))
	}
	
	func isOn() -> Bool
	{
		return !self.meets(threshold: .OFF)
	}
	
	func threshold() -> Threshold
	{
		let t = rawValue & 0b00001111
		switch t
		{
			case 1: return .DEBUG
			case 2: return .INFO
			case 4: return .WARN
			case 8: return .ERROR
			default: return .OFF
		}
	}
	
	private func meets(degree: Threshold) -> Bool
	{
		let minLvl = degree.rawValue % Threshold.SESSION.rawValue
		let selfLvl = self.rawValue % Threshold.SESSION.rawValue
		return selfLvl >= minLvl
	}
}

fileprivate let levelMap: [String: Threshold] = [
											"DEBUG" : .DEBUG,
											"INFO" : .INFO,
											"WARN" : .WARN,
											"ERROR" : .ERROR,
											"SESSION" : .SESSION,
											"TIME" : .TIME,
											"NOTIFICATIONS" : .NOTIFICATIONS,
											"OFF" : .OFF
											]
