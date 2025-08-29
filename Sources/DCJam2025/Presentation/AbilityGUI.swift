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
        
        for i in 0 ..< partyMember.abilities.count {
            let ability = partyMember.abilities[i]
            
            let y = Float(210 + i * 24)
            result.append(GUIText(position: Vector2(x: 20, y: y), text: "\(i + 1): \(ability.key)", color: .white, fontSize: 20))
            
            result.append(GUIButton(position: Vector2(x: 100, y: y), size: Vector2(x: 20, y: 20), text: "-", enabled: true, action: { removeAbility(ability) }))
        }
        
        result.append(GUIButton(position: Vector2(x: 20, y: Float(210 + partyMember.abilities.count * 24)), size: Vector2(x: 100, y: 20), text: "Add ability", enabled: true, action: { addAbility() }))
        
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
