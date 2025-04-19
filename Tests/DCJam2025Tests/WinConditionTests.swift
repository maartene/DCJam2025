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
    
    @Test("be 'won' when the party reaches the target tile") func wonGame() {
        let world = World(map: Floor([
            ["S","T"]
        ]))
        
        world.moveParty(.right)
        
        #expect(world.state == .won)
    }
    
    @Test("not allow movement when the party reaches the target") func winningGameMakesMovementImpossible() {
        let world = World(map: Floor([
            ["S","T"]
        ]))
        
        world.moveParty(.right)
        world.moveParty(.left)
        
        #expect(world.partyPosition == Coordinate(x: 1, y: 0))
    }
    
    @Test("not allow rotation when the party reaches the target") func winningGameMakesRotationImpossible() {
        let world = World(map: Floor([
            ["S","T"]
        ]))
        
        world.moveParty(.right)
        world.turnPartyClockwise()
        
        #expect(world.partyHeading == .north)
    }
}
