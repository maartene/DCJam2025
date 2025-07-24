//
//  PartyMember.swift
//  DCJam2025
//
//  Created by Maarten Engels on 24/04/2025.
//

import Foundation

public final class PartyMember: Damageable {
    public enum Hand {
        case primary, secondary
    }

    public let name: String
    public private(set) var currentHP = 10
    private var cooldownExpires = [
        Hand.primary: Date(),
        Hand.secondary: Date(),
        ]
    private var cooldown = 2.0
    private(set) var primaryHand: any AttackMobStrategy
    private(set) var secondaryHand: any AttackMobStrategy

    init (name: String, primaryHand: AttackMobStrategy, secondaryHand: AttackMobStrategy) {
        self.name = name
        self.primaryHand = primaryHand
        self.secondaryHand = secondaryHand
    }

    public var isAlive: Bool {
        currentHP > 0
    }

    public func takeDamage(_ amount: Int) {
        currentHP -= amount
    }

    public func cooldownHasExpired(for hand: Hand, at time: Date) -> Bool {
        time >= cooldownExpires[hand]!
    }

    func abilityForHand(hand: Hand) -> AttackMobStrategy {
        switch hand {
            case .primary: primaryHand
            case .secondary: secondaryHand
        }
    }

    func executeHandAbility(hand: Hand, in world: World, at time: Date) {
        let attackStrategy = abilityForHand(hand: hand)

        guard cooldownHasExpired(for: hand, at: time) else {
            return
        }
        
        guard isAlive else {
            return
        }
        
        attackStrategy.damageTargets(in: world)
        
        cooldownExpires[hand] = time.addingTimeInterval(cooldown)
    }
}

extension PartyMember {
    public static func makeMeleePartyMember(name: String) -> PartyMember {
        PartyMember(name: name, primaryHand: MeleeAttackMobStrategy(), secondaryHand: MeleeAttackMobStrategy())
    }
    public static func makeRangedPartyMember(name: String) -> PartyMember {
        PartyMember(name: name, primaryHand: RangedAttackMobStrategy(), secondaryHand: RangedAttackMobStrategy())
    }
    public static func makeMagicPartyMember(name: String) -> PartyMember {
        PartyMember(name: name, primaryHand: MagicAttackMobStrategy(), secondaryHand: MagicAttackMobStrategy())
    }
}

extension PartyMember {
    public func setAttackStrategyToMelee() {
        primaryHand = MeleeAttackMobStrategy()
        secondaryHand = MeleeAttackMobStrategy()
    }
}