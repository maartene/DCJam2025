//
//  RangedAttackStrategy.swift
//  DCJam2025
//
//  Created by Maarten Engels on 26/06/2025.
//


struct RangedAttackStrategy: AttackStrategy {
    let range = 3
    let damage = 1
    
    func getValidTargets(in world: World) -> [PartyMember] {
        world.partyMembers.all
            .filter { $0.isAlive }
    }
}