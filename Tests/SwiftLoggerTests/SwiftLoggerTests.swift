//
//  Test.swift
//  SwiftLogger
//
//  Created by Robert Schmid on 10/2/2025.
//

import Testing
import SwiftLogger

struct Test
{		
	@Test func testLog() async throws {
		await Log.debug("Debug Statement")
		await Log.info("Info Statement")
		await Log.warn("Warn Statement")
		await Log.error("Error Statement")
//		Log.markTimerStart(msg: "Start Timer")
//		Log.markTime(msg: "Check Lap")
//		Log.markTimerEnd(msg: "End Timer")
	}
}
