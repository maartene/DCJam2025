//
//  GUI.swift
//  DCJam2025
//
//  Created by Maarten Engels on 10/08/2025.
//

import raylib
import Model
import Foundation

struct GUI {
    weak var world: World?
    let sprites: [String: Texture]
    
    func drawParty() {
        GuiSetState(GuiState.normal)

        drawPartyMember(.frontLeft, position: Vector2(x: 890, y: 10))
        drawPartyMember(.frontRight, position: Vector2(x: 890 + 185 + 10, y: 10))
        drawPartyMember(.backLeft, position: Vector2(x: 890, y: 170))
        drawPartyMember(.backRight, position: Vector2(x: 890 + 185 + 10, y: 170))
    }

    private func drawPartyMember(_ memberPosition: SinglePartyPosition, position: Vector2) {
        guard let world else {
            return
        }
        
        let partyMember = world.partyMembers[memberPosition]
        let x = Int32(position.x)
        let y = Int32(position.y)
        let fontSize: Int32 = 24
        
        DrawRectangle(x, y, 185, 150, .darkGray)
        
        DrawText(partyMember.name, x + 5, y, fontSize, .white)
        
        if let portrait = sprites[partyMember.name] {
            DrawTexture(portrait, x + 5, y + 25, .white)
        }
        
        let attackButtonSize = Vector2(x: 70, y: 40)
        
        drawAttackButtonFor(memberPosition, hand: .primary, position: position + Vector2(x: 5 + 100 + 5, y: 25), size: attackButtonSize)
        drawAttackButtonFor(memberPosition, hand: .secondary, position: position + Vector2(x: 5 + 100 + 5, y: 25 + attackButtonSize.y), size: attackButtonSize)
        
        drawHPBar(currentHP: partyMember.currentHP, maxHP: 10, position: position + Vector2(x: 5, y: 130))
    }

    private func drawAttackButtonFor(_ memberPosition: SinglePartyPosition, hand: PartyMember.Hand, position: Vector2, size: Vector2) {
        guard let world else {
            return
        }
        
        let saveGuiState = GuiGetState()
        let buttonRectangle = Rectangle(x: position.x, y: position.y, width: size.x, height: size.y)
        let partyMember = world.partyMembers[memberPosition]
        let attackName = partyMember.weaponForHand(hand: hand).name
        
        if partyMember.canExecuteAbility(for: hand, at: Date()) {
            if (GuiButton(buttonRectangle, attackName)) == 1 {
                world.executeCommand(.executeHandAbility(user: memberPosition, hand: hand), at: Date())
            }
        } else {
            GuiSetState(GuiState.disabled)
            GuiButton(buttonRectangle, attackName)
        }
        GuiSetState(saveGuiState)
    }

    private func drawHPBar(currentHP: Int, maxHP: Int, position: Vector2) {
        // label:
        let x = Int32(position.x)
        let y = Int32(position.y)
        DrawText("HP: ", x, y, 16, .white)
        
        // outer bar:
        DrawRectangleV(position + Vector2(x: 30, y: 0), Vector2(x: 145, y: 15), .white)
        
        // inner bar:
        let maxWidth: Float = 145 - 4
        let size = Float(currentHP) / Float(maxHP) * maxWidth
        
        DrawRectangleV(position + Vector2(x: 30 + 2, y: 2), Vector2(x: size, y: 15 - 4), hpBarColor(currentHP: currentHP, maxHP: maxHP))
    }
}

