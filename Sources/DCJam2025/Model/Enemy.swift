//
//  Enemy.swift
//  DCJam2025
//
//  Created by Maarten Engels on 29/05/2025.
//

import Foundation

class Enemy {
    private(set) var position: Coordinate
    private(set) var heading: CompassDirection
    private var cooldownExpires = Date()
    let cooldown = 0.75
    private let range: Int
    private let damage: Int
    let attackStrategy: any AttackStrategy

    init(position: Coordinate, heading: CompassDirection, range: Int, damage: Int, attackStrategy: any AttackStrategy) {
        self.position = position
        self.heading = heading
        self.range = range
        self.damage = damage
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
        
        guard partyIsInRange(in: world, range: range) else {
            return
        }
        
        attackParty(in: world, at: time)
        cooldownExpires = time.addingTimeInterval(cooldown)
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
    
    func attackParty(in world: World, at time: Date) {
        let potentialTargets = attackStrategy.getValidTargets(in: world)
            
        potentialTargets.randomElement()?.takeDamage(attackStrategy.damage)
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
    
    init(position: Coordinate, heading: CompassDirection) {
        super.init(position: position, heading: heading, range: Self.MELEE_RANGE, damage: Self.MELEE_DAMAGE, attackStrategy: MeleeAttackStrategy())
    }
}

final class RangedEnemy: Enemy {
    private static let RANGED_ATTACK_RANGE = 3
    private static let RANGED_ATTACK_DAMAGE = 1

    init(position: Coordinate, heading: CompassDirection) {
        super.init(position: position, heading: heading, range: Self.RANGED_ATTACK_RANGE, damage: Self.RANGED_ATTACK_DAMAGE, attackStrategy: RangedAttackStrategy())
    }

    override func attackParty(in world: World, at time: Date) {
        let alivePartyMembers = world.partyMembers.all
            .filter { $0.isAlive }
        
        alivePartyMembers.randomElement()?.takeDamage(Self.RANGED_ATTACK_DAMAGE)
        
    }
}

extension Enemy {
    static func makeMeleeEnemy(at position: Coordinate, heading: CompassDirection = .west) -> Enemy {
        Enemy(position: position, heading: heading, range: 1, damage: 1, attackStrategy: MeleeAttackStrategy())
    }
    static func makeRangedEnemy(at position: Coordinate, heading: CompassDirection = .west) -> RangedEnemy {
        RangedEnemy(position: position, heading: heading)
    }
}


protocol AttackStrategy {
    var range: Int { get }
    var damage: Int { get }
    
    func getValidTargets(in world: World) -> [PartyMember]
}

struct MeleeAttackStrategy: AttackStrategy {
    let range = 1
    let damage = 2
    
    func getValidTargets(in world: World) -> [PartyMember] {
        world.partyMembers.frontRow
            .filter { $0.isAlive }
    }
    
    func partyIsInRange(in world: World, enemyPosition: Coordinate) -> Bool {
        let manhattanDistance = abs(world.partyPosition.x - enemyPosition.x) + abs(world.partyPosition.y - enemyPosition.y)
        return manhattanDistance <= range
    }
}

struct RangedAttackStrategy: AttackStrategy {
    let range = 2
    let damage = 1
    
    func getValidTargets(in world: World) -> [PartyMember] {
        world.partyMembers.all
            .filter { $0.isAlive }
    }
    
    func partyIsInRange(in world: World, enemyPosition: Coordinate) -> Bool {
        let manhattanDistance = abs(world.partyPosition.x - enemyPosition.x) + abs(world.partyPosition.y - enemyPosition.y)
        return manhattanDistance <= range
    }
}
