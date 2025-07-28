//
//  AttackMobStrategy.swift
//  DCJam2025
//
//  Created by Maarten Engels on 23/07/2025.
//

public protocol AttackMobStrategy: AttackStrategy, Sendable {
    var allowedPartyPositions: PartyPositionGroup { get }
    var allowedHands: [PartyMember.Hand] { get }
}

extension AttackMobStrategy {
    var allowedPartyPositions: PartyPositionGroup { .all }
    var allowedHands: [PartyMember.Hand] {
        [.primary, .secondary] 
    }
    
    func getValidTargets(in world: World) -> [Damageable] {
        let partyPosition = world.partyPosition
        let enemiesInRange = world.aliveEnemiesOnCurrentFloor.filter {
            partyPosition.manhattanDistanceTo($0.position) <= range
        }
        
        let enemiesInFrontOfParty = enemiesInRange.filter {
            var position = partyPosition
            for i in 0 ... range {
                if $0.position == position {
                    return true
                }
                position += world.partyHeading.forward
            }
            return false
        }
        
        return Array(enemiesInFrontOfParty)
    }
}

struct MeleeAttackMobStrategy: AttackMobStrategy {
    let range = 1
    let damage = 2
    
    let allowedPartyPositions: PartyPositionGroup = .frontRow
}

struct RangedAttackMobStrategy: AttackMobStrategy {
    let range = 3
    let damage = 1
    let allowedHands = [PartyMember.Hand.primary]
}

struct MagicAttackMobStrategy: AttackMobStrategy {
    let range = 2
    let damage = 1
    
    func damageTargets(in world: World) {
        let potentialTargets = getValidTargets(in: world)
        potentialTargets.forEach { $0.takeDamage(damage) }
    }
}
