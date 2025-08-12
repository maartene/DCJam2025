//
//  GUI.swift
//  DCJam2025
//
//  Created by Maarten Engels on 10/08/2025.
//

import raylib
import Model
import Foundation

protocol GUIDrawable {
    var position: Vector2 { get }
    func draw()
}

struct GUIRectangle: GUIDrawable {
    let position: Vector2
    let size: Vector2
    let color: Color

    func draw() {
        DrawRectangle(Int32(position.x), Int32(position.y), Int32(size.x), Int32(size.y), color)
    }
}

struct GUIText: GUIDrawable {
    let position: Vector2
    let text: String
    let color: Color
    let fontSize: Int32

    func draw() {
        DrawText(text, Int32(position.x), Int32(position.y), fontSize, .white)
    }
}

struct GUITexture: GUIDrawable {
    let position: Vector2
    let texture: Texture
    let color: Color

    func draw() {
        DrawTexture(texture, Int32(position.x), Int32(position.y), color)
    }
}

struct GUIButton: GUIDrawable {
    let position: Vector2
    let size: Vector2
    let text: String
    let enabled: Bool
    let action: () -> Void

    func draw() {
        let saveGuiState = GuiGetState()
        let buttonRectangle = Rectangle(x: position.x, y: position.y, width: size.x, height: size.y)
        if enabled {
            if (GuiButton(buttonRectangle, text)) == 1 {
                action()
            }
        } else {
            GuiSetState(GuiState.disabled)
            GuiButton(buttonRectangle, text)
        }
        GuiSetState(saveGuiState)
    }
}

struct GUI {
    weak var world: World?
    let sprites: [String: Texture]

    func drawParty() -> [any GUIDrawable] {
        GuiSetState(GuiState.normal)

        var result = [any GUIDrawable]()

        result.append(contentsOf: drawPartyMember(.frontLeft, position: Vector2(x: 890, y: 10)))
        result.append(contentsOf: drawPartyMember(.frontRight, position: Vector2(x: 890 + 185 + 10, y: 10)))
        result.append(contentsOf: drawPartyMember(.backLeft, position: Vector2(x: 890, y: 170)))
        result.append(contentsOf: drawPartyMember(.backRight, position: Vector2(x: 890 + 185 + 10, y: 170)))

        return result
    }

    private func drawPartyMember(_ memberPosition: SinglePartyPosition, position: Vector2) -> [any GUIDrawable] {
        guard let world else {
            return []
        }

        var result = [any GUIDrawable]()
        let partyMember = world.partyMembers[memberPosition]
        let x = position.x
        let y = position.y
        let fontSize: Int32 = 24

        result.append(GUIRectangle(position: Vector2(x: x, y: y), size: Vector2(x: 185, y: 150), color: .darkGray))

        result.append(GUIText(position: Vector2(x: x + 5, y: y), text: partyMember.name, color: .white, fontSize: fontSize))

        if let portrait = sprites[partyMember.name] {
            result.append(GUITexture(position: Vector2(x: x + 5, y: y + 25), texture: portrait, color: .white))
        }

        let attackButtonSize = Vector2(x: 70, y: 40)

        result.append(contentsOf: drawAttackButtonFor(memberPosition, hand: .primary, position: position + Vector2(x: 5 + 100 + 5, y: 25), size: attackButtonSize))
        result.append(contentsOf: drawAttackButtonFor(memberPosition, hand: .secondary, position: position + Vector2(x: 5 + 100 + 5, y: 25 + attackButtonSize.y), size: attackButtonSize))

        result.append(contentsOf: drawHPBar(currentHP: partyMember.currentHP, maxHP: 10, position: position + Vector2(x: 5, y: 130)))

        return result
    }

    private func drawAttackButtonFor(_ memberPosition: SinglePartyPosition, hand: PartyMember.Hand, position: Vector2, size: Vector2) -> [any GUIDrawable] {
        guard let world else {
            return []
        }

        let partyMember = world.partyMembers[memberPosition]
        let attackName = partyMember.weaponForHand(hand: hand).name

        return [
            GUIButton(position: position, size: size, text: attackName, enabled: partyMember.canExecuteAbility(for: hand, at: Date())) {
                world.executeCommand(.executeHandAbility(user: memberPosition, hand: hand), at: Date())
            }
        ]
    }

    private func drawHPBar(currentHP: Int, maxHP: Int, position: Vector2) -> [any GUIDrawable] {
        var result = [any GUIDrawable]()

        // label:
        result.append(GUIText(position: position, text: "HP: ", color: .white, fontSize: 16))

        // outer bar:
        result.append(GUIRectangle(position: position + Vector2(x: 30, y: 0), size: Vector2(x: 145, y: 15), color: .white))

        // inner bar:
        let maxWidth: Float = 145 - 4
        let size = Float(currentHP) / Float(maxHP) * maxWidth

        result.append(GUIRectangle(position: position + Vector2(x: 30 + 2, y: 2), size: Vector2(x: size, y: 15 - 4), color: hpBarColor(currentHP: currentHP, maxHP: maxHP)))

        return result
    }
}
