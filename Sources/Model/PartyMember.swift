//
//  PartyMember.swift
//  DCJam2025
//
//  Created by Maarten Engels on 24/04/2025.
//

import Foundation

public final class PartyMember: Damageable {
    public let name: String
    public private(set) var currentHP = 10
    private var cooldownExpires = Date()
    private var cooldown = 1.0
    let attackStrategy = MeleeAttackMobStrategy()

    init (name: String) {
        self.name = name
    }

    public var isAlive: Bool {
        currentHP > 0
    }

    public func takeDamage(_ amount: Int) {
        currentHP -= amount
    }

    public func cooldownHasExpired(at time: Date) -> Bool {
        time >= cooldownExpires
    }

    func attack(in world: World, at time: Date) {
        guard cooldownHasExpired(at: time) else {
            return
        }
        
        guard isAlive else {
            return
        }
        
        attackStrategy.damageTargets(in: world)
        
        cooldownExpires = time.addingTimeInterval(cooldown)
    }
}
