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
    public let maximumHP: Int = 10
    private let cooldown = 2.0
    private var cooldownExpiresNew = Date()

    init (name: String) {
        self.name = name
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
    
    func executeAbility(_ ability: any Ability, in world: World, at time: Date) {
        guard canExecuteAbility(ability, at: time) else {
            return
        }
        
        ability.execute(in: world)
        
        cooldownExpiresNew = Date().addingTimeInterval(cooldown)
    }
    
    public func canExecuteAbility(_ ability: any Ability, at time: Date) -> Bool {
        guard cooldownExpiresNew <= time else {
            return false
        }
        
        guard isAlive else {
            return false
        }
        
        return true
    }
}

extension PartyMember {
    public static func makeMeleePartyMember(name: String) -> PartyMember {
        PartyMember(name: name)
    }
    public static func makeRanger(name: String) -> PartyMember {
        let newPartyMember = PartyMember(name: name)
        return newPartyMember
    }
    public static func makeMage(name: String) -> PartyMember {
        let newPartyMember = PartyMember(name: name)
        return newPartyMember
    }
}
