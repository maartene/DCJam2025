//
//  WinConditionTests.swift
//  DCJam2025
//
//  Created by Maarten Engels on 13/04/2025.
//

import Testing
import Foundation
@testable import DCJam2025

@Suite("The wincondition for this world should") struct WinConditionTests {
    let worldWithTarget = World(floors: [Floor([
        ["S", "T"]
    ])])

    @Test("be 'inProgress' for a new World") func newGame() {
        let world = World(floors: [Floor()])

        #expect(world.state == .inProgress)
    }

    @Test("be 'won' when the party reaches the target tile") func wonGame() {
        worldWithTarget.executeCommand(.move(direction: .right), at: Date())

        #expect(worldWithTarget.state == .won)
    }

    @Test("not allow movement when the party reaches the target") func winningGameMakesMovementImpossible() {
        worldWithTarget.executeCommand(.move(direction: .right), at: Date())
        worldWithTarget.executeCommand(.move(direction: .left), at: Date())

        #expect(worldWithTarget.partyPosition == Coordinate(x: 1, y: 0))
    }

    @Test("not allow rotation when the party reaches the target") func winningGameMakesRotationImpossible() {
        worldWithTarget.executeCommand(.move(direction: .right), at: Date())
        worldWithTarget.executeCommand(.turnClockwise, at: Date())

        #expect(worldWithTarget.partyHeading == .north)
    }
}
