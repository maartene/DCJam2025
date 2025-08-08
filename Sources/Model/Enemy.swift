//
//  Enemy.swift
//  DCJam2025
//
//  Created by Maarten Engels on 29/05/2025.
//

import Foundation

public final class Enemy: Damageable {
    public private(set) var position: Coordinate
    public private(set) var heading: CompassDirection
    private var cooldownExpires = Date()
    public let cooldown = 0.75
    private let attackStrategy: any AttackPartyStrategy
    public private(set) var hp: Int

    init(position: Coordinate, heading: CompassDirection, attackStrategy: any AttackPartyStrategy, hp: Int = 3) {
        self.position = position
        self.heading = heading
        self.attackStrategy = attackStrategy
        self.hp = hp
    }

    public var isAlive: Bool {
        hp > 0
    }

    public func takeDamage(_ amount: Int) {
        hp -= amount
    }

    func act(in world: World, at time: Date) {
        guard enemyCooldownHasExpired(at: time) else {
            return
        }

        guard hasLineOfSight(world.partyPosition, in: world) else {
            return
        }

        guard attackStrategy.partyIsInRange(in: world, enemyPosition: position) else {
            move(in: world, at: time)
            return
        }

        guard isFacingParty(in: world) else {
            rotateTowardsParty(in: world, at: time)
            return
        }

        attackParty(in: world, at: time)
    }

    private func enemyCooldownHasExpired(at time: Date) -> Bool {
        cooldownExpires <= time
    }

    private func hasLineOfSight(_ targetPosition: Coordinate, in world: World) -> Bool {
        let line = Coordinate.plotLine(from: position, to: targetPosition)
        return line
            .filter { world.currentFloor.tileAt($0) == .wall }
            .isEmpty
    }

    private func isFacingParty(in world: World) -> Bool {
        isFacingCoordinate(world.partyPosition)
    }

    private func isFacingCoordinate(_ coordinate: Coordinate) -> Bool {
        // naive raycast approach
        for i in 0 ..< 20 {
            if position + (heading.forward * i) == coordinate {
                return true
            }
        }
        return false
    }

    private func rotateTowardsParty(in world: World, at time: Date) {
        rotateTowardsCoordinate(world.partyPosition, at: time)
    }

    private func rotateTowardsCoordinate(_ coordinate: Coordinate, at time: Date) {
        let originalHeading = heading

        for _ in 0 ..< 4 {
            if isFacingCoordinate(coordinate) {
                cooldownExpires = time.addingTimeInterval(cooldown)
                print("New heading: \(heading)")
                return
            } else {
                heading = heading.rotatedClockwise()
            }
        }

        heading = originalHeading
    }

    private func move(in world: World, at time: Date) {
        let path = world.pathToParty(from: position)

        guard let nextPosition = path.first(where: { $0.distanceTo(position) == 1 }) else {
            return
        }

        guard isFacingCoordinate(nextPosition) else {
            rotateTowardsCoordinate(nextPosition, at: time)
            return
        }

        cooldownExpires = time.addingTimeInterval(cooldown)
        position = nextPosition
    }

    private func attackParty(in world: World, at time: Date) {
        attackStrategy.damageTargets(in: world)
        cooldownExpires = time.addingTimeInterval(cooldown)
    }
}

extension Enemy: Hashable {
    public static func == (lhs: Enemy, rhs: Enemy) -> Bool {
        lhs === rhs
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension Enemy {
    public static func makeMeleeEnemy(at position: Coordinate, heading: CompassDirection = .west) -> Enemy {
        Enemy(position: position, heading: heading, attackStrategy: MeleeAttackPartyStrategy())
    }
    public static func makeRangedEnemy(at position: Coordinate, heading: CompassDirection = .west) -> Enemy {
        Enemy(position: position, heading: heading, attackStrategy: RangedAttackPartyStrategy())
    }
    public static func makeMagicEnemy(at position: Coordinate, heading: CompassDirection = .west) -> Enemy {
        Enemy(position: position, heading: heading, attackStrategy: MagicAttackPartyStrategy())
    }
    public static func makePracticeDummy(at position: Coordinate, heading: CompassDirection = .west) -> Enemy {
        Enemy(position: position, heading: heading, attackStrategy: DummyAttackStrategy(), hp: 100)
    }
}
