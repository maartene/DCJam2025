//
//  LostConditionTests.swift
//  DCJam2025
//
//  Created by Maarten Engels on 24/04/2025.
//

import Testing
@testable import DCJam2025

@Suite struct LoseConditionTests {
    @Test("When all party members are rendered unconcious, the game is lost") func loseWhenAllPartyMembersAreUnconscious() {
        let world = World(map: Floor())
        
        world.partyMembers[0].takeDamage(Int.max)
        world.partyMembers[1].takeDamage(Int.max)
        world.partyMembers[2].takeDamage(Int.max)
        world.partyMembers[3].takeDamage(Int.max)
        
        #expect(world.state == .defeated)
    }
    
    @Test("When at least one party member is alive, the game is not lost") func notLostWhenAtLeastOnePartyMemberIsAlive() {
        let world = World(map: Floor())
        
        world.partyMembers[0].takeDamage(Int.max)
        world.partyMembers[1].takeDamage(Int.max)
        world.partyMembers[2].takeDamage(Int.max)
        
        #expect(world.state != .defeated)
    }
}
