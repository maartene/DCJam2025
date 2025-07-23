//
//  AttackMobStrategy.swift
//  DCJam2025
//
//  Created by Maarten Engels on 23/07/2025.
//

protocol AttackMobStrategy: AttackStrategy {
    var allowedPartyPositions: PartyPositionGroup { get }
}

extension AttackMobStrategy {
    var allowedPartyPositions: PartyPositionGroup { .all }
    
    func getValidTargets(in world: World) -> [Damageable] {
        let partyPosition = world.partyPosition
        return world.enemiesOnCurrentFloor.filter {
            partyPosition.manhattanDistanceTo($0.position) <= range
        }
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
}

struct MagicAttackMobStrategy: AttackMobStrategy {
    let range = 2
    let damage = 1
}
