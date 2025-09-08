//
//  AbilityGUI.swift
//  DCJam2025
//
//  Created by Maarten Engels on 29/08/2025.
//

// compose abilities

import Foundation
import Model
import raylib

public final class AbilityGUI {
    let sprites: [String: Texture]
    let fontsizes: [Int32: Font]
    let partyMember: PartyMember
    private var currentlySelectedAbilityIndex: Int?
    
    init(
        sprites: [String: Texture], fontsizes: [Int32: Font], partyMember: PartyMember,
    ) {
        self.sprites = sprites
        self.fontsizes = fontsizes
        self.partyMember = partyMember
    }

    func draw() -> [GUIDrawable] {
        let width: Float = 1280 - 10 - 10
        let height: Float = 720 - 10 - 10

        var result = [GUIDrawable]()

        result.append(
            GUIRectangle(
                position: Vector2(x: 10, y: 10), size: Vector2(x: width, y: height),
                color: Color(r: 80, g: 80, b: 80, a: 192)))

        result.append(
            GUIText(
                font: fontsizes[36], position: Vector2(x: 20, y: 20), text: partyMember.name,
                color: .white))

        if let portrait = sprites[partyMember.name] {
            result.append(
                GUITexture(position: Vector2(x: 20, y: 20 + 42), texture: portrait, color: .white))
        }

        result.append(
            GUIText(
                font: fontsizes[24], position: Vector2(x: 20, y: 180), text: "Abilities:",
                color: .white))

        result.append(
            GUIText(
                font: fontsizes[20], position: Vector2(x: 20, y: 210), text: "Select", color: .white
            ))

        result.append(
            GUIText(
                font: fontsizes[20], position: Vector2(x: 100, y: 210), text: "Components",
                color: .white))

        result.append(
            GUIText(
                font: fontsizes[20], position: Vector2(x: 230, y: 210), text: "Actions",
                color: .white))

        for abilityIndex in 0..<partyMember.abilities.count {
            let ability = partyMember.abilities[abilityIndex]

            let yPosition = Float(240 + abilityIndex * 24)

            if currentlySelectedAbilityIndex == abilityIndex {
                result.append(
                    GUIRectangle(
                        position: Vector2(x: 20 - 2, y: yPosition - 2),
                        size: Vector2(x: 280 + 4, y: 24),
                        color: .darkPurple,
                        groupingID: "Abilities")
                )
            }

            result.append(
                GUIButton(
                    position: Vector2(x: 20, y: yPosition), size: Vector2(x: 40, y: 20),
                    text: "(\(abilityIndex + 1))",
                    enabled: true,
                    groupingID: "Abilities",
                    action: { [weak self] in self?.currentlySelectedAbilityIndex = abilityIndex }))

            let keys: [Character] = ability.key.map { $0 }

            for keyIndex in 0..<keys.count {
                let key = keys[keyIndex]
                result.append(
                    GUIButton(
                        position: Vector2(x: Float(100 + 22 * keyIndex), y: yPosition),
                        size: Vector2(x: 20, y: 20), text: String(key), enabled: true,
                        groupingID: "Abilities",
                        action: {
                            [weak self] in self?.removeComponent(componentKey: String(key), abilityIndex: abilityIndex)
                        }))
            }

            result.append(
                GUIButton(
                    position: Vector2(x: 230, y: yPosition), size: Vector2(x: 20, y: 20), text: "-",
                    enabled: true,
                    groupingID: "Abilities",
                    action: { [weak self] in self?.removeAbility(ability) }))
        }

        result.append(
            GUIButton(
                position: Vector2(x: 20, y: Float(240 + partyMember.abilities.count * 24 + 5)),
                size: Vector2(x: 100, y: 20), text: "Add ability", enabled: true,
                groupingID: "Abilities",
                action: { [weak self] in self?.addAbility() }))

        result.append(
            GUIText(
                font: fontsizes[24],
                position: Vector2(x: 20, y: Float(280 + partyMember.abilities.count * 24)),
                text: "Available Abilities:", color: .white))

        let allAbilities = allAbilities()
        for abilityIndex in 0..<allAbilities.count {
            let ability = allAbilities[abilityIndex]
            if let selectedAbilityIndex = currentlySelectedAbilityIndex {
                result.append(
                    GUIButton(
                        position: Vector2(
                            x: Float(20 + abilityIndex * 24),
                            y: Float(310 + partyMember.abilities.count * 24)),
                        size: Vector2(x: 20, y: 20), text: "\(ability.key)", enabled: true,
                        groupingID: "AvailableAbilities",
                        action: {
                            [weak self] in self?.partyMember.addComponentToAbility(
                                component: ability, to: selectedAbilityIndex)
                        }))
            } else {
                result.append(
                    GUIButton(
                        position: Vector2(
                            x: Float(20 + abilityIndex * 24),
                            y: Float(310 + partyMember.abilities.count * 24)),
                        size: Vector2(x: 20, y: 20), text: "\(ability.key)", enabled: false,
                        groupingID: "AvailableAbilities",
                        action: {}))
            }
        }

        return result
    }

    func removeAbility(_ ability: any Ability) {
        partyMember.deleteAbility(ability)
    }

    func addAbility() {
        partyMember.addAbility()
    }

    func removeComponent(componentKey: String, abilityIndex: Int) {
        partyMember.removeComponentFromAbility(componentKey: componentKey, from: abilityIndex)
    }
}
