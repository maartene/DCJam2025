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
    private(set) var attackStrategy: any AttackMobStrategy

    init (name: String, attackStrategy: AttackMobStrategy) {
        self.name = name
        self.attackStrategy = attackStrategy
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

extension PartyMember {
    public static func makeMeleePartyMember(name: String) -> PartyMember {
        PartyMember(name: name, attackStrategy: MeleeAttackMobStrategy())
    }
    public static func makeRangedPartyMember(name: String) -> PartyMember {
        PartyMember(name: name, attackStrategy: RangedAttackMobStrategy())
    }
    public static func makeMagicPartyMember(name: String) -> PartyMember {
        PartyMember(name: name, attackStrategy: MagicAttackMobStrategy())
    }
}

extension PartyMember {
    public func setAttackStrategyToMelee() {
        attackStrategy = MeleeAttackMobStrategy()
    }
}
