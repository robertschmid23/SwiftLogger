//
//  GlobalLogActor.swift
//  SwiftLogger
//
//  Created by Robert Schmid on 10/2/2025.
//

@globalActor
public actor GlobalLogActor {
	public static nonisolated let shared = GlobalLogActor()
}
