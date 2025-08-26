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
    public var abilities: [any Ability] = []
    public let positionInParty: SinglePartyPosition

    init (name: String, positionInParty: SinglePartyPosition) {
        self.name = name
        self.positionInParty = positionInParty
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
        
        ability.execute(by: self, in: world)
        
        cooldownExpiresNew = Date().addingTimeInterval(cooldown)
    }
    
    public func canExecuteAbility(_ ability: any Ability, at time: Date) -> Bool {
        guard cooldownExpiresNew <= time else {
            return false
        }
        
        guard isAlive else {
            return false
        }
        
        guard abilities.contains(where: { $0.key == ability.key }) else {
            return false
        }
        
        return true
    }
}

extension PartyMember {
    public static func makeMeleePartyMember(name: String, position: SinglePartyPosition) -> PartyMember {
        let newPartyMember = PartyMember(name: name, positionInParty: position)
        
        newPartyMember.abilities = [
            DamageEnemyAbility()
        ]
        
        return newPartyMember
    }
    public static func makeRanger(name: String, position: SinglePartyPosition) -> PartyMember {
        let newPartyMember = makeMeleePartyMember(name: name, position: position)
        
        return newPartyMember
    }
    public static func makeMage(name: String, position: SinglePartyPosition) -> PartyMember {
        let newPartyMember = makeMeleePartyMember(name: name, position: position)
        
        return newPartyMember
    }
}
