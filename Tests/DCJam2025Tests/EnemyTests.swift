//
//  EnemyTests.swift
//  DCJam2025
//
//  Created by Maarten Engels on 24/04/2025.
//

import Testing
import Foundation
@testable import DCJam2025

@Suite("Enemies should") struct EnemyTests {
    @Test("attack party members when they are close enough") func enemiesAttackPartyMembers() {
        let world = World(map: Floor([
            ["S","s"]
        ]))
        
        let hpOfPartyMembersBeforeAttack = world.partyMembers
            .map { $0.currentHP }
            .reduce(0, +)
        
        world.update(at: Date())
        
        let hpOfPartyMembersAfterAttack = world.partyMembers
            .map { $0.currentHP }
            .reduce(0, +)
        
        #expect(hpOfPartyMembersBeforeAttack > hpOfPartyMembersAfterAttack)
    }
}
