//
//  Enemy.swift
//  DCJam2025
//
//  Created by Maarten Engels on 29/05/2025.
//

import Foundation

final class Enemy {
    private(set) var position: Coordinate
    private(set) var heading: CompassDirection
    private var cooldownExpires = Date()
    let cooldown = 0.75
    private let attackStrategy: any AttackStrategy

    init(position: Coordinate, heading: CompassDirection, attackStrategy: any AttackStrategy) {
        self.position = position
        self.heading = heading
        self.attackStrategy = attackStrategy
    }

    
    func act(in world: World, at time: Date) {
        guard enemyCooldownHasExpired(at: time) else {
            return
        }
        
        guard isFacingParty(in: world) else {
            rotateTowardsParty(in: world, at: time)
            return
        }
        
        guard attackStrategy.partyIsInRange(in: world, enemyPosition: position) else {
            moveForward()
            return
        }
        
        attackParty(in: world, at: time)
    }

    private func enemyCooldownHasExpired(at time: Date) -> Bool {
        cooldownExpires <= time
    }
    
    private func isFacingParty(in world: World) -> Bool {
        // naive raycast approach
        for i in 0 ..< 20 {
            if position + (heading.forward * i) == world.partyPosition {
                return true
            }
        }
        return false
    }
    
    private func rotateTowardsParty(in world: World, at time: Date) {
        let originalHeading = heading
        
        for _ in 0 ..< 4 {
            if isFacingParty(in: world) {
                cooldownExpires = time.addingTimeInterval(cooldown)
                print("New heading: \(heading)")
                return
            } else {
                heading = heading.rotatedClockwise()
            }
        }
        
        heading = originalHeading
    }
    
    private func moveForward() {
        position += heading.toCoordinate
    }
    
    private func attackParty(in world: World, at time: Date) {
        attackStrategy.damageTargets(in: world)
        cooldownExpires = time.addingTimeInterval(cooldown)
    }
}

extension Enemy: Hashable {
    static func == (lhs: Enemy, rhs: Enemy) -> Bool {
        lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension Enemy {
    static func makeMeleeEnemy(at position: Coordinate, heading: CompassDirection = .west) -> Enemy {
        Enemy(position: position, heading: heading,  attackStrategy: MeleeAttackStrategy())
    }
    static func makeRangedEnemy(at position: Coordinate, heading: CompassDirection = .west) -> Enemy {
        Enemy(position: position, heading: heading, attackStrategy: RangedAttackStrategy())
    }
    static func makeMagicEnemy(at position: Coordinate, heading: CompassDirection = .west) -> Enemy {
        Enemy(position: position, heading: heading, attackStrategy: MagicAttackStrategy())
    }
}
