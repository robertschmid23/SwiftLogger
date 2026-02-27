//
//  NumberFormatter.swift
//  SwiftLogger
//
//  Created by Robert Schmid on 10/2/2025.

//

import Foundation

//String(format: ...) has a memory leak.  Probably due to bridging to NSString.
//This will be a specialized version that will be lighter weight and not leaky
final class TimeString
{
	enum Symbols: String { case SPACE = " ", DOT = ".", ZERO = "0" }
	enum Justify { case LEFT, RIGHT }
	
	private let percentF = NumberFormatter()
	private let durationF = NumberFormatter()
	
	init() {
		percentF.numberStyle = .percent
		percentF.maximumFractionDigits = 3
		
		durationF.numberStyle = .decimal
		durationF.maximumFractionDigits = 3
		#if os(macOS)
		durationF.hasThousandSeparators = true
		#endif
	}
	
	private func numWidth(num: Int) -> Int
	{
		let w = (num == 0 ? 1 : Int(log10(Double(num))) + 1)
		return w
	}
	
	func rate(num: Int, denom: Int) -> String
	{
		let rate = Double(num)/Double(denom)
		return percentF.string(for: rate)!
	}
	
	func from(intValue: Int, width: Int? = 0, pad: Symbols? = .SPACE, justify: Justify? = .RIGHT) -> String
	{
		var str = ""

		var padding = width! - numWidth(num: intValue)
		if justify == .LEFT
		{
			str.append("\(intValue)")
		}
		while (padding > 0)
		{
			str.append(pad!.rawValue)
			padding -= 1
		}
		
		if justify == .RIGHT
		{
			str.append("\(intValue)")
		}
		return str
	}
	
	func from(doubleValue: Double, decimals: Int, width: Int? = 0, pad: Symbols? = .SPACE) -> String
	{
		var str = ""
		let i = Int(doubleValue)
		let decimalPlaces = pow(10.0,Double(decimals))
		let dec = from(intValue: Int(decimalPlaces * doubleValue.truncatingRemainder(dividingBy: 1) + 0.5), width: decimals, pad: .ZERO)
		if let w = width
		{
			var padding = w - numWidth(num: i)
			while (padding > 0)
			{
				str.append(pad!.rawValue)
				padding -= 1
			}
		}
		
		str.append("\(i)")
		str.append(Symbols.DOT.rawValue)
		
		str.append(dec)
		return str
	}
	
	func duration(from time: Double) -> String
	{
		let timeUnit = time < 1 ? "ms" : time < 60 ? "sec" : ""
		let duration = time < 1 ? time * 1000.0 : time
		let formatted = durationF.string(for: duration)!
		return "\(formatted) \(timeUnit)"
	}
}
