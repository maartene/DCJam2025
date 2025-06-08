//
//  AttackStrategy.swift
//  DCJam2025
//
//  Created by Maarten Engels on 07/06/2025.
//

protocol AttackStrategy {
    var range: Int { get }
    var damage: Int { get }
    
    func getValidTargets(in world: World) -> [PartyMember]
    func damageTargets(in world: World)
}

extension AttackStrategy {
    func partyIsInRange(in world: World, enemyPosition: Coordinate) -> Bool {
        let manhattanDistance = abs(world.partyPosition.x - enemyPosition.x) + abs(world.partyPosition.y - enemyPosition.y)
        return manhattanDistance <= range
    }
    
    func damageTargets(in world: World) {
        let potentialTargets = getValidTargets(in: world)
        potentialTargets.randomElement()?.takeDamage(damage)
    }
}

struct MeleeAttackStrategy: AttackStrategy {
    let range = 1
    let damage = 2
    
    func getValidTargets(in world: World) -> [PartyMember] {
        world.partyMembers.frontRow
            .filter { $0.isAlive }
    }
}

struct RangedAttackStrategy: AttackStrategy {
    let range = 3
    let damage = 1
    
    func getValidTargets(in world: World) -> [PartyMember] {
        world.partyMembers.all
            .filter { $0.isAlive }
    }
}

struct MagicAttackStrategy: AttackStrategy {
    let range = 2
    let damage = 1
    
    func getValidTargets(in world: World) -> [PartyMember] {
        world.partyMembers.all
            .filter { $0.isAlive }
    }
    
    func damageTargets(in world: World) {
        let potentialTargets = getValidTargets(in: world)
        potentialTargets.forEach { $0.takeDamage(damage) }
    }
}
