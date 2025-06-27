//
//  AttackStrategy.swift
//  DCJam2025
//
//  Created by Maarten Engels on 07/06/2025.
//

protocol AttackPartyStrategy {
    var range: Int { get }
    var damage: Int { get }
    
    func getValidTargets(in world: World) -> [PartyMember]
    func damageTargets(in world: World)
}

extension AttackPartyStrategy {
    func partyIsInRange(in world: World, enemyPosition: Coordinate) -> Bool {
        let manhattanDistance = world.partyPosition.manhattanDistanceTo(enemyPosition)
        return manhattanDistance <= range
    }
    
    func damageTargets(in world: World) {
        let potentialTargets = getValidTargets(in: world)
        potentialTargets.randomElement()?.takeDamage(damage)
    }
}

struct MeleeAttackStrategy: AttackPartyStrategy {
    let range = 1
    let damage = 2
    
    func getValidTargets(in world: World) -> [PartyMember] {
        world.partyMembers.getMembers(grouping: .frontRow)
            .filter { $0.isAlive }
    }
}

struct RangedAttackStrategy: AttackPartyStrategy {
    let range = 3
    let damage = 1
    
    func getValidTargets(in world: World) -> [PartyMember] {
        world.partyMembers.getMembers(grouping: .all)
            .filter { $0.isAlive }
    }
}

struct MagicAttackStrategy: AttackPartyStrategy {
    let range = 2
    let damage = 1
    
    func getValidTargets(in world: World) -> [PartyMember] {
        world.partyMembers.getMembers(grouping: .all)
            .filter { $0.isAlive }
    }
    
    func damageTargets(in world: World) {
        let potentialTargets = getValidTargets(in: world)
        potentialTargets.forEach { $0.takeDamage(damage) }
    }
}
