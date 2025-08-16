//
//  PartyMember.swift
//  DCJam2025
//
//  Created by Maarten Engels on 24/04/2025.
//

import Foundation

public final class PartyMember: Damageable {
    public enum Hand: Sendable {
        case primary, secondary
    }

    public let name: String
    public private(set) var currentHP = 10
    public let maximumHP: Int = 10
    private var cooldownExpires = [
        Hand.primary: Date(),
        Hand.secondary: Date()
        ]
    private var cooldown = 2.0
    public private(set) var primaryHand: Weapon
    public private(set) var secondaryHand: Weapon

    init (name: String, primaryHand: Weapon = .bareHands, secondaryHand: Weapon = .bareHands) {
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
    
    public func heal(_ amount: Int) {
        currentHP += amount
        
        currentHP = min(maximumHP, currentHP)
    }

    private func cooldownHasExpired(for hand: Hand, at time: Date) -> Bool {
        time >= cooldownExpires[hand]!
    }

    public func canExecuteAbility(for hand: Hand, at time: Date) -> Bool {
        guard cooldownHasExpired(for: hand, at: time) else {
            return false
        }

        guard isAlive else {
            return false
        }

        if weaponForHand(hand: hand).twoHanded && hand == .secondary {
            return false
        }

        return true
    }

    public func weaponForHand(hand: Hand) -> Weapon {
        switch hand {
        case .primary: primaryHand
        case .secondary: secondaryHand
        }
    }

    public func equipWeapon(_ weapon: Weapon, in hand: Hand) {
        if primaryHand.twoHanded {
            primaryHand = .bareHands
            secondaryHand = .bareHands
        }

        if weapon.twoHanded {
            primaryHand = weapon
            secondaryHand = weapon
        } else {
            switch hand {
            case .primary:
                primaryHand = weapon
            case .secondary:
                primaryHand = weapon
            }
        }
    }

    func executeHandAbility(hand: Hand, in world: World, at time: Date) {
        let attackStrategy = weaponForHand(hand: hand).attackStrategy

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
        PartyMember(name: name)
    }
    public static func makeRanger(name: String) -> PartyMember {
        let newPartyMember = PartyMember(name: name)
        newPartyMember.equipWeapon(.bow, in: .primary)
        return newPartyMember
    }
    public static func makeMage(name: String) -> PartyMember {
        let newPartyMember = PartyMember(name: name)
        newPartyMember.equipWeapon(.staff, in: .primary)
        return newPartyMember
    }
}
