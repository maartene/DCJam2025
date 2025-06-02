//
//  EnemyTests.swift
//  DCJam2025
//
//  Created by Maarten Engels on 24/04/2025.
//

import Testing
import Foundation
@testable import DCJam2025

@Suite("During update, melee enemies should") struct MeleeEnemyTests {
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
            [MeleeEnemy(position: Coordinate(x: 10, y: 0))]
        ])
        
        let hpOfPartyMembersBeforeAttack = sumHPOfPartyMembers(in: world)

        world.update(at: Date())

        let hpOfPartyMembersAfterUpdate = sumHPOfPartyMembers(in: world)

        #expect(hpOfPartyMembersBeforeAttack == hpOfPartyMembersAfterUpdate)
    }

    @Test("not attack party members if enemy is still in cooldown") func enemiesDontAttackDuringCooldown() {
        let enemy = MeleeEnemy(position: Coordinate(x: 1, y: 0))
        let world = World(floors: [Floor()], enemies: [[enemy]])
        
        world.update(at: Date())
        let hpOfPartyMembersAfterFirstAttack = sumHPOfPartyMembers(in: world)

        world.update(at: Date().addingTimeInterval(enemy.cooldown * 0.5))

        #expect(sumHPOfPartyMembers(in: world) == hpOfPartyMembersAfterFirstAttack)
    }

    @Test("attack party members after cooldown has expired") func enemiesAttackAfterCooldownHasExpired() {
        let enemy = MeleeEnemy(position: Coordinate(x: 1, y: 0))
        let world = World(floors: [Floor()], enemies: [[enemy]])
        
        world.update(at: Date())
        let hpOfPartyMembersAfterFirstAttack = sumHPOfPartyMembers(in: world)

        world.update(at: Date().addingTimeInterval(enemy.cooldown * 1.5))

        #expect(sumHPOfPartyMembers(in: world) < hpOfPartyMembersAfterFirstAttack)
    }
    
    @Test("only attacks alive party members") func enemiesOnlyAttackAlivePartyMembers() {
        let enemy = MeleeEnemy(position: Coordinate(x: 1, y: 0))
        let world = World(floors: [Floor()], enemies: [[enemy]])
        world.partyMembers.frontLeft.takeDamage(Int.max)
        let originalHPForFrontRightPartyMember = world.partyMembers.frontRight.currentHP
        
        world.update(at: Date())
        
        #expect(world.partyMembers.frontRight.currentHP < originalHPForFrontRightPartyMember)
    }
}

@Suite("Ranged enemies should") struct RangedEnemyTests {
    @Test("attack party members in the back row") func rangedEnemiesAttackPartyMembersInTheBackRow() {
        let world = makeWorld(from: [
            ".r"
        ])

        world.partyMembers.frontLeft.takeDamage(Int.max)
        world.partyMembers.frontRight.takeDamage(Int.max)
        
        let originalHPForPartyMembersInBackRow = sumHPOfPartyMembersInBackRow(in: world)

        world.update(at: Date())
        
        #expect(sumHPOfPartyMembersInBackRow(in: world) < originalHPForPartyMembersInBackRow)
    }

    @Test("attack enemies that are out of melee range") func rangedEnemiesAttackPartyMembersThatAreOutOfMeleeRange() {
        let world = makeWorld(from: [
            "..r"
        ])       
        let originalHPOfPartyMember = sumHPOfPartyMembers(in: world)

        world.update(at: Date())
        
        #expect(sumHPOfPartyMembers(in: world) < originalHPOfPartyMember)
    }

    @Test("cannot attack enemies that are out of range") func rangedEnemiesCannotAttackPartyMembersThatAreOutOfRange() {
        let world = makeWorld(from: [
            "....r"
        ])       
        let originalHPOfPartyMember = sumHPOfPartyMembers(in: world)

        world.update(at: Date())
        
        #expect(sumHPOfPartyMembers(in: world) == originalHPOfPartyMember)
    }

    @Test("deal less damage than a melee enemy") func rangedEnemiesDealLessDamageThanMeleeEnemies() {
        let world1 = makeWorld(from: [
            ".s",
        ])

        let world2 = makeWorld(from: [
            ".r",
        ])
        
        world1.update(at: Date())
        world2.update(at: Date())

        #expect(sumHPOfPartyMembers(in: world1) < sumHPOfPartyMembers(in: world2))
    }
}

private func sumHPOfPartyMembers(in world: World) -> Int {
    world.partyMembers.frontLeft.currentHP +
    world.partyMembers.frontRight.currentHP +
    world.partyMembers.backLeft.currentHP +
    world.partyMembers.backRight.currentHP
}

private func sumHPOfPartyMembersInBackRow(in world: World) -> Int {
    world.partyMembers.backRow
    .map { $0.currentHP }
    .reduce(0, +)
}
