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
    private let attackStrategy: any AttackPartyStrategy
    var hp = 3

    init(position: Coordinate, heading: CompassDirection, attackStrategy: any AttackPartyStrategy) {
        self.position = position
        self.heading = heading
        self.attackStrategy = attackStrategy
    }

    var isAlive: Bool {
        hp > 0
    }
    
    func damage(amount: Int) {
        hp -= amount
    }

    func act(in world: World, at time: Date) {
        guard enemyCooldownHasExpired(at: time) else {
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

        guard let nextPosition = path.first(where: { $0.distanceTo(position) == 1 } ) else {
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
