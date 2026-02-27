//
//  File.swift
//  
//
//  Created by Robert Schmid on 10/2/2025.
//

import Foundation

struct TimerKey: Hashable, Equatable
{
	var file: String
	var funcName: String
	var line: Int
	var blockId:String = ""
	
	init(file: String, funcName: String, line: Int, blockId:String = "")
	{
		self.file = file
		self.funcName = funcName
		self.line = line
		self.blockId = blockId
	}
	
	func candidateMatch(newKey: TimerKey) -> Bool
	{
		return self.file == newKey.file &&
				self.funcName == newKey.funcName &&
				self.blockId == newKey.blockId &&
				self.line < newKey.line
	}
}
