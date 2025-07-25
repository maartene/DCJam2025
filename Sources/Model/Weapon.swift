//
//  AttackMobStrategy.swift
//  DCJam2025
//
//  Created by Maarten Engels on 23/07/2025.
//

public protocol Weapon: AttackStrategy {
    var allowedPartyPositions: PartyPositionGroup { get }
    var allowedHands: [PartyMember.Hand] { get }
    var weaponType: WeaponType { get }
}

extension Weapon {
    var allowedPartyPositions: PartyPositionGroup { .all }
    var allowedHands: [PartyMember.Hand] {
        [.primary, .secondary] 
    }
    
    func getValidTargets(in world: World) -> [Damageable] {
        let partyPosition = world.partyPosition
        return world.enemiesOnCurrentFloor.filter {
            partyPosition.manhattanDistanceTo($0.position) <= range
        }
    }

    var weaponType: WeaponType {
        .bareHands
    }
}

struct MeleeAttackMobStrategy: Weapon {
    let range = 1
    let damage = 2
    
    let allowedPartyPositions: PartyPositionGroup = .frontRow
}

struct RangedAttackMobStrategy: Weapon {
    let range = 3
    let damage = 1
    let allowedHands = [PartyMember.Hand.primary]
    let weaponType: WeaponType = .bow
}

struct MagicAttackMobStrategy: Weapon {
    let range = 2
    let damage = 1
    
    func damageTargets(in world: World) {
        let potentialTargets = getValidTargets(in: world)
        potentialTargets.forEach { $0.takeDamage(damage) }
    }
}

public enum WeaponType {
    case bareHands
    case bow
}