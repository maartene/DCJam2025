//
//  Enemy.swift
//  DCJam2025
//
//  Created by Maarten Engels on 29/05/2025.
//

import Foundation

class Enemy {
    init(position: Coordinate, heading: CompassDirection) {
        self.position = position
        self.heading = heading
    }

    private(set) var position: Coordinate
    private(set) var heading: CompassDirection
    var cooldownExpires = Date()
    let cooldown = 0.75

    func act(in world: World, at time: Date) {
        // This method should be overridden by subclasses
    }

    internal func enemyCooldownHasExpired(at time: Date) -> Bool {
        cooldownExpires <= time
    }

    internal func partyIsInRange(in world: World, range: Int) -> Bool {
        let manhattanDistance = abs(world.partyPosition.x - position.x) + abs(world.partyPosition.y - position.y)
        return manhattanDistance <= range
    }
    
    internal func isFacingParty(in world: World) -> Bool {
        // naive raycast approach
        for i in 0 ..< 20 {
            if position + (heading.forward * i) == world.partyPosition {
                return true
            }
        }
        return false
    }
    
    func rotateTowardsParty(in world: World, at time: Date) {
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
}

extension Enemy: Hashable {
    static func == (lhs: Enemy, rhs: Enemy) -> Bool {
        lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

final class MeleeEnemy: Enemy {
    private static let MELEE_RANGE = 1
    private static let MELEE_DAMAGE = 2
    
    override func act(in world: World, at time: Date) {
        if partyIsInRange(in: world, range: Self.MELEE_RANGE) && enemyCooldownHasExpired(at: time) && isFacingParty(in: world) {
            attackParty(in: world, at: time)
            return
        }
        
        if enemyCooldownHasExpired(at: time) {
            // rotate towards party
            rotateTowardsParty(in: world, at: time)
        }
    }
    
    private func attackParty(in world: World, at time: Date) {
        let aliveFrontRowPartyMembers = world.partyMembers.frontRow
            .filter { $0.isAlive }

        aliveFrontRowPartyMembers.randomElement()?.takeDamage(Self.MELEE_DAMAGE)
        cooldownExpires = time.addingTimeInterval(cooldown)
    }
}

final class RangedEnemy: Enemy {
    private static let RANGED_ATTACK_RANGE = 3
    private static let RANGED_ATTACK_DAMAGE = 1

    override func act(in world: World, at time: Date) {
        if partyIsInRange(in: world, range: Self.RANGED_ATTACK_RANGE) && enemyCooldownHasExpired(at: time) {
            attackParty(in: world, at: time)
        }
    }

    private func attackParty(in world: World, at time: Date) {
        let alivePartyMembers = world.partyMembers.all
            .filter { $0.isAlive }
        
        alivePartyMembers.randomElement()?.takeDamage(Self.RANGED_ATTACK_DAMAGE)
        cooldownExpires = time.addingTimeInterval(cooldown)
    }
}

extension Enemy {
    static func makeMeleeEnemy(at position: Coordinate, heading: CompassDirection = .west) -> MeleeEnemy {
        MeleeEnemy(position: position, heading: heading)
    }
    static func makeRangedEnemy(at position: Coordinate, heading: CompassDirection = .west) -> RangedEnemy {
        RangedEnemy(position: position, heading: heading)
    }
}
