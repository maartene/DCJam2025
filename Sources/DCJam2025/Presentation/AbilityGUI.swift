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

public struct AbilityGUI {
    let sprites: [String: Texture]
    let partyMember: PartyMember
    weak var viewModel: AbilityGUIViewModel?
    
    init(sprites: [String : Texture], partyMember: PartyMember, viewModel: AbilityGUIViewModel) {
        self.sprites = sprites
        self.partyMember = partyMember
        self.viewModel = viewModel
    }
    
    func draw() -> [GUIDrawable] {
        let width: Float = 1280 - 10 - 10
        let height: Float = 720 - 10 - 10
        
        var result = [GUIDrawable]()
        
        result.append(GUIRectangle(position: Vector2(x: 10, y: 10), size: Vector2(x: width, y: height), color: .darkGray))
        
        result.append(GUIText(position: Vector2(x: 20, y: 20), text: partyMember.name, color: .white, fontSize: 36))
        
        if let portrait = sprites[partyMember.name] {
            result.append(GUITexture(position: Vector2(x: 20, y: 20 + 42), texture: portrait, color: .white))
        }
        
        result.append(GUIText(position: Vector2(x: 20, y: 180), text: "Abilities:", color: .white, fontSize: 24))
        
        result.append(GUIText(position: Vector2(x: 20, y: 210), text: "Select  Ability Components  Remove", color: .white, fontSize: 20))
        
        for i in 0 ..< partyMember.abilities.count {
            let ability = partyMember.abilities[i]
            let color = i == viewModel?.currentlySelectedAbilityIndex ? Color.blue : Color.white
            
            let y = Float(240 + i * 24)
            result.append(GUIButton(position: Vector2(x: 20, y: y), size: Vector2(x: 20, y: 20), text: "\(i + 1):", enabled: true, action: { viewModel?.currentlySelectedAbilityIndex = i }))

            let keys: [Character] = "abcd".map { $0 }
            
            if viewModel?.currentlySelectedAbilityIndex == i {
                result.append(GUIText(position: Vector2(x: 50, y: y), text: ">            <", color: .white, fontSize: 20))
            }
            
            for j in 0 ..< keys.count {
                let key = keys[j]
                result.append(GUIButton(position: Vector2(x: Float(60 + 22 * j), y: y), size: Vector2(x: 20, y: 20), text: String(key), enabled: true, action: {
                    
                }))
            }
            
            result.append(GUIButton(position: Vector2(x: 180, y: y), size: Vector2(x: 20, y: 20), text: "-", enabled: true, action: { removeAbility(ability) }))
        }
        
        
        result.append(GUIButton(position: Vector2(x: 20, y: Float(240 + partyMember.abilities.count * 24 + 5)), size: Vector2(x: 100, y: 20), text: "Add ability", enabled: true, action: { addAbility() }))
        
        result.append(GUIText(position: Vector2(x: 20, y: Float(280 + partyMember.abilities.count * 24)), text: "Available Abilities:", color: .white, fontSize: 24))
        
        let allAbilities = allAbilities()
        for i in 0 ..< allAbilities.count {
            let ability = allAbilities[i]
            result.append(GUIButton(position: Vector2(x: Float(20 + i * 24), y: Float(310 + partyMember.abilities.count * 24)), size: Vector2(x: 20, y: 20), text: "\(ability.key)", enabled: true, action: { } ))
        }
        
        return result
    }
    
    func removeAbility(_ ability: any Ability) {
        if let abilityIndex = partyMember.abilities.firstIndex(where: { $0.key == ability.key }) {
            partyMember.abilities.remove(at: abilityIndex)
        }
    }
    
    func addAbility() {
        partyMember.abilities.append(DummyAbility())
    }
}

struct DummyAbility: Ability {
    let effect: EffectSignature = { _,_,_ in }
    
    func execute(by partyMember: PartyMember, in world: World) {
        
    }
    
    let key: String = ""
    
    let properties: [String : Any] = [:]
}

final class AbilityGUIViewModel {
    var currentlySelectedAbilityIndex: Int?
}
