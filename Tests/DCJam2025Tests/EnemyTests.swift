//
//  EnemyTests.swift
//  DCJam2025
//
//  Created by Maarten Engels on 24/04/2025.
//

import Testing
import Foundation
@testable import DCJam2025

@Suite("During update, enemies should") struct EnemyTests {
    @Test("attack party members when they are close enough") func enemiesAttackPartyMembers() {
        let world = makeWorld(from: [
            ".s"
        ])

        let hpOfPartyMembersBeforeAttack = sumHPOfPartyMembers(in: world)

        world.update(at: Date())

        let hpOfPartyMembersAfterAttack = sumHPOfPartyMembers(in: world)

        #expect(hpOfPartyMembersBeforeAttack > hpOfPartyMembersAfterAttack)
    }

    @Test("not attack party members when they are not close enough") func enemiesDontAttackPartyMembersOutOfRange() {
        let world = World(floors: [Floor()], enemies: [
            [Enemy(position: Coordinate(x: 10, y: 0))]
        ])
        
        let hpOfPartyMembersBeforeAttack = sumHPOfPartyMembers(in: world)

        world.update(at: Date())

        let hpOfPartyMembersAfterUpdate = sumHPOfPartyMembers(in: world)

        #expect(hpOfPartyMembersBeforeAttack == hpOfPartyMembersAfterUpdate)
    }

    private func sumHPOfPartyMembers(in world: World) -> Int {
        world.partyMembers
            .map { $0.currentHP }
            .reduce(0, +)
    }
}
