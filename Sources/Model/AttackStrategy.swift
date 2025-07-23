//
//  AttackStrategy.swift
//  DCJam2025
//
//  Created by Maarten Engels on 23/07/2025.
//

protocol AttackStrategy {
    var range: Int { get }
    var damage: Int { get }

    func getValidTargets(in world: World) -> [Damageable]
    func damageTargets(in world: World)
}

extension AttackStrategy {
    func damageTargets(in world: World) {
        let potentialTargets = getValidTargets(in: world)
        potentialTargets.randomElement()?.takeDamage(damage)
    }
}

protocol Damageable {
    func takeDamage(_ amount: Int)
}
