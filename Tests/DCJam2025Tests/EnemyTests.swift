//
//  EnemyTests.swift
//  DCJam2025
//
//  Created by Maarten Engels on 24/04/2025.
//

import Testing
import Foundation
import Model

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
            [.makeMeleeEnemy(at: Coordinate(x: 10, y: 0), heading: .west)]
        ])

        let hpOfPartyMembersBeforeAttack = sumHPOfPartyMembers(in: world)

        world.update(at: Date())

        let hpOfPartyMembersAfterUpdate = sumHPOfPartyMembers(in: world)

        #expect(hpOfPartyMembersBeforeAttack == hpOfPartyMembersAfterUpdate)
    }

    @Test("not attack party members if enemy is still in cooldown") func enemiesDontAttackDuringCooldown() {
        let enemy = Enemy.makeMeleeEnemy(at: Coordinate(x: 1, y: 0), heading: .west)
        let world = World(floors: [Floor()], enemies: [[enemy]])

        world.update(at: Date())
        let hpOfPartyMembersAfterFirstAttack = sumHPOfPartyMembers(in: world)

        world.update(at: Date().addingTimeInterval(enemy.cooldown * 0.5))

        #expect(sumHPOfPartyMembers(in: world) == hpOfPartyMembersAfterFirstAttack)
    }

    @Test("attack party members after cooldown has expired") func enemiesAttackAfterCooldownHasExpired() {
        let enemy = Enemy.makeMeleeEnemy(at: Coordinate(x: 1, y: 0), heading: .west)
        let world = World(floors: [Floor()], enemies: [[enemy]])

        world.update(at: Date())
        let hpOfPartyMembersAfterFirstAttack = sumHPOfPartyMembers(in: world)

        world.update(at: Date().addingTimeInterval(enemy.cooldown * 1.5))

        #expect(sumHPOfPartyMembers(in: world) < hpOfPartyMembersAfterFirstAttack)
    }

    @Test("only attacks alive party members") func enemiesOnlyAttackAlivePartyMembers() {
        let enemy = Enemy.makeMeleeEnemy(at: Coordinate(x: 1, y: 0), heading: .west)
        let world = World(floors: [Floor()], enemies: [[enemy]])
        world.partyMembers[.frontLeft].takeDamage(Int.max)
        let originalHPForFrontRightPartyMember = world.partyMembers[.frontRight].currentHP

        world.update(at: Date())

        #expect(world.partyMembers[.frontRight].currentHP < originalHPForFrontRightPartyMember)
    }

    @Test("rotates towards a party when its not facing party")
    func enemiesRotateTowardsPartyWhenItsNotFacingParty() throws {
        let world = makeWorld(from: [
            """
            ..
            s.
            """
        ])

        world.update(at: Date())
        let enemy = try #require(world.enemiesOnCurrentFloor.first)
        #expect(enemy.heading == .south)
    }

    @Test("dead enemies don't attack") func deadEnemiesDontAttack() {
        let enemy = Enemy.makeMeleeEnemy(at: Coordinate(x: 1, y: 0), heading: .west)
        let world = World(floors: [Floor()], enemies: [[enemy]])
        enemy.takeDamage(Int.max)
        let hpOfPartyMembersBeforeAttack = sumHPOfPartyMembers(in: world)

        world.update(at: Date())

        #expect(sumHPOfPartyMembers(in: world) == hpOfPartyMembersBeforeAttack)
    }
}

@Suite("Ranged enemies should") struct RangedEnemyTests {
    @Test("attack party members in the back row") func rangedEnemiesAttackPartyMembersInTheBackRow() {
        let world = makeWorld(from: [
            ".r"
        ])

        world.partyMembers[.frontLeft].takeDamage(Int.max)
        world.partyMembers[.frontRight].takeDamage(Int.max)

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
            ".s"
        ])

        let world2 = makeWorld(from: [
            ".r"
        ])

        world1.update(at: Date())
        world2.update(at: Date())

        #expect(sumHPOfPartyMembers(in: world1) < sumHPOfPartyMembers(in: world2))
    }
}

@Suite("Magic enemies should") struct MagicEnemyTests {
    @Test("Hit multiple party members") func magicEnemiesHitMultiplePartyMembers() {
        let world = makeWorld(from: [
            """
            .e
            """
        ])
        let originalHpOfPartyMembers = world.partyMembers.getMembers(grouping: .all).map { $0.currentHP }

        world.update(at: Date())

        let hpOfPartyMembersAfterAttack = world.partyMembers.getMembers(grouping: .all).map { $0.currentHP }

        let numberOfPartyMembersWithLessHP = zip(originalHpOfPartyMembers, hpOfPartyMembersAfterAttack)
            .filter { $0.0 > $0.1 }
            .count
        #expect(numberOfPartyMembersWithLessHP > 1)
    }
}

@Suite("Practice dummies should") struct PracticeDummyTests {
    @Test("not attack") func notAttack() {
        let world = makeWorld(from: [
            """
            .p
            """
        ])

        let originalHpOfPartyMembers = sumHPOfPartyMembers(in: world)

        world.update(at: Date())

        #expect(sumHPOfPartyMembers(in: world) == originalHpOfPartyMembers)
    }
}

@Suite("Enemies should try and move towards party to get near them") struct EnemyMovementTests {
    @Test("Enemies move towards party") func enemiesMoveTowardsParty() throws {
        let world = makeWorld(from: [
            "..s"
        ])
        let enemy = try #require(world.enemiesOnCurrentFloor.first)

        world.update(at: Date())

        #expect(enemy.position == Coordinate(x: 1, y: 0))
    }

    @Test("Enemies find a path towards the party") func enemiesFindAPathTowardsTheParty() throws {
        let world = makeWorld(from: [
            """
            ...
            .#.
            .s.
            """
        ])

        let enemy = try #require(world.enemiesOnCurrentFloor.first)
        var time = Date()

        world.update(at: time)
        #expect(enemy.heading == .west)
        time += enemy.cooldown

        world.update(at: time)
        #expect(enemy.position == Coordinate(x: 0, y: 2))
        time += enemy.cooldown

        world.update(at: time)
        #expect(enemy.heading == .south)
        time += enemy.cooldown

        world.update(at: time)
        #expect(enemy.position == Coordinate(x: 0, y: 1))
        time += enemy.cooldown
    }

    @Test("Increase cooldown after rotating") func rotatingConsumesCooldown() throws {
        let world = makeWorld(from: [
            """
            ...
            s..
            """
        ])

        let originalHPOfPartyMembers = sumHPOfPartyMembers(in: world)
        world.update(at: Date())
        world.update(at: Date())

        #expect(sumHPOfPartyMembers(in: world) == originalHPOfPartyMembers)
    }

    @Test("Increase cooldown after moving") func movingConsumesCooldown() throws {
        let world = makeWorld(from: [
            "..s"
        ])

        let originalHPOfPartyMembers = sumHPOfPartyMembers(in: world)
        world.update(at: Date())
        world.update(at: Date())

        #expect(sumHPOfPartyMembers(in: world) == originalHPOfPartyMembers)
    }

    @Test("not move towards the party when there is no line of sight") func enemiesOnlyMoveWithLineOfSight() throws {
        let world = makeWorld(from: [
            """
            .#.s
            ....
            """
        ])

        let enemy = try #require(world.enemiesOnCurrentFloor.first)

        world.update(at: Date())
        world.update(at: Date().addingTimeInterval(enemy.cooldown))

        #expect(enemy.position == Coordinate(x: 3, y: 0))
    }
}

// MARK: Helper functions

private func sumHPOfPartyMembers(in world: World) -> Int {
    world.partyMembers.getMembers(grouping: .all)
        .map { $0.currentHP }
        .reduce(0, +)
}

private func sumHPOfPartyMembersInBackRow(in world: World) -> Int {
    world.partyMembers.getMembers(grouping: .backRow)
    .map { $0.currentHP }
    .reduce(0, +)
}
