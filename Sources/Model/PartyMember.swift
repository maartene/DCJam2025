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

    public func addAbility(_ ability: Ability = DummyAbility()) {
        abilities.append(ability)
    }

    public func deleteAbility(_ ability: Ability) {
        guard let abilityIndex = abilities.firstIndex(where: { $0.key == ability.key }) else {
            return
        }

        abilities.remove(at: abilityIndex)
    }

    public func addComponentToAbility(component: any Ability, to abilityToChangeIndex: Int) {
        guard (0 ..< abilities.count).contains(abilityToChangeIndex) else {
            return
        }

        abilities[abilityToChangeIndex] = combine(abilities[abilityToChangeIndex], component)
    }

    public func removeComponentFromAbility(componentKey: String, from abilityToChangeIndex: Int) {
        let abilityToChange = abilities[abilityToChangeIndex]

        let allAbilities = allAbilities()
         var existingComponents = abilityToChange.key.map { String($0) }
         .compactMap { existingComponentKey in
            allAbilities.first(where: { allAbility in
            allAbility.key == existingComponentKey
            })
        }

        let componentToRemove = existingComponents.firstIndex { $0.key == componentKey }!

        existingComponents.remove(at: componentToRemove)

        abilities[abilityToChangeIndex] = combine(existingComponents)
    }
}

extension PartyMember {
    public static func makeMeleePartyMember(name: String, position: SinglePartyPosition) -> PartyMember {
        let newPartyMember = PartyMember(name: name, positionInParty: position)

        newPartyMember.abilities = [
            combine(DamageEnemyAbility(), AddPotencyAbility()),
            combine(DamageEnemyAbility())
        ]

        return newPartyMember
    }
    public static func makeRanger(name: String, position: SinglePartyPosition) -> PartyMember {
        let newPartyMember = makeMeleePartyMember(name: name, position: position)

        newPartyMember.abilities = [
            combine(DamageEnemyAbility(), AddRangeAbility())
        ]

        return newPartyMember
    }
    public static func makeMage(name: String, position: SinglePartyPosition) -> PartyMember {
        let newPartyMember = makeMeleePartyMember(name: name, position: position)

        newPartyMember.abilities = [
            DamageEnemyAbility(),
            combine(HealPartyMember(), AddAoEAbility())
        ]

        return newPartyMember
    }
}
