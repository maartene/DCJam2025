//
//  WinConditionTests.swift
//  DCJam2025
//
//  Created by Maarten Engels on 13/04/2025.
//

import Testing
@testable import DCJam2025

@Suite("The wincondition for this world should") struct WinConditionTests {
    @Test("be 'inProgress' for a new World") func newGame() {
        let world = World(map: Floor())
        
        #expect(world.state == .inProgress)
    }
}
