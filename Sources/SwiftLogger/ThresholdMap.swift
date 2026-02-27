//
//  ThresholdMap.swift
//  SwiftLogger
//
//  Created by Robert Schmid on 10/2/2025.
//

import Foundation

class ThresholdMap
{
	private var levels: [(String, String)] = []

	func add(file: String, funcName: String)
	{
		self.levels.append( (file, funcName) )
	}
	
	func index(file: String, funcName: String) -> Int?
	{
		return levels.firstIndex(where: {$0 == (file, funcName)})
	}
	
	var count: Int { return levels.count }
}
