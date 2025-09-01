//
//  GUI.swift
//  DCJam2025
//
//  Created by Maarten Engels on 10/08/2025.
//

import Foundation
import Model
import raygui
import raylib

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
    private static let baseTextSize: Int32 = 64
    private static let baseSpacingForImportTextSize: Float = 4
    static let imageRenderMultiplier: Int32 = 2
    let font: Font
    let position: Vector2
    let text: String
    let color: Color

    init(font: Font?, position: Vector2, text: String, color: Color) {
        self.font = font ?? Font()
        self.position = position
        self.text = text
        self.color = color
    }

    var fontSize: Float {
        Float(font.baseSize / Self.imageRenderMultiplier)
    }

    var spacing: Float {
        Self.baseSpacingForImportTextSize * fontSize / Float(Self.baseTextSize)
    }

    func draw() {
        DrawTextEx(font, text, position, fontSize, spacing, color)
        // GuiLabel(Rectangle(x: position.x, y: position.y, width: 200, height: 30), text)

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
    let fontsizes: [Int32: Font]

    func drawParty() -> [any GUIDrawable] {
        GuiSetState(GuiState.normal)

        var result = [any GUIDrawable]()

        result.append(contentsOf: drawPartyMember(.frontLeft, position: Vector2(x: 890, y: 10)))
        result.append(
            contentsOf: drawPartyMember(.frontRight, position: Vector2(x: 890 + 185 + 10, y: 10)))
        result.append(contentsOf: drawPartyMember(.backLeft, position: Vector2(x: 890, y: 170)))
        result.append(
            contentsOf: drawPartyMember(.backRight, position: Vector2(x: 890 + 185 + 10, y: 170)))

        return result
    }

    private func drawPartyMember(_ memberPosition: SinglePartyPosition, position: Vector2)
        -> [any GUIDrawable]
    {
        guard let world else {
            return []
        }

        var result = [any GUIDrawable]()
        let partyMember = world.partyMembers[memberPosition]
        let x = position.x
        let y = position.y
        let fontSize: Float = 24

        result.append(
            GUIRectangle(
                position: Vector2(x: x, y: y), size: Vector2(x: 185, y: 150), color: .darkGray))

        result.append(
            GUIText(
                font: fontsizes[Int32(fontSize)], position: Vector2(x: x + 5, y: y),
                text: partyMember.name, color: .white))

        if let portrait = sprites[partyMember.name] {
            result.append(
                GUITexture(position: Vector2(x: x + 5, y: y + 25), texture: portrait, color: .white)
            )
        }

        let attackButtonSize = Vector2(x: 70, y: 40)

        for abilityIndex in 0..<partyMember.abilities.count {
            let ability = partyMember.abilities[abilityIndex]
            result.append(
                contentsOf: drawAttackButtonFor(
                    memberPosition, ability: ability,
                    position: position
                        + Vector2(x: 5 + 100 + 5, y: 25 + attackButtonSize.y * Float(abilityIndex)),
                    size: attackButtonSize))
        }

        result.append(
            contentsOf: drawHPBar(
                currentHP: partyMember.currentHP, maxHP: 10,
                position: position + Vector2(x: 5, y: 130)))

        return result
    }

    private func drawAttackButtonFor(
        _ memberPosition: SinglePartyPosition, ability: any Ability, position: Vector2,
        size: Vector2
    ) -> [any GUIDrawable] {
        guard let world else {
            return []
        }

        let partyMember = world.partyMembers[memberPosition]

        return [
            GUIButton(
                position: position, size: size, text: ability.key,
                enabled: partyMember.canExecuteAbility(ability, at: Date())
            ) {
                world.executeCommand(
                    .executeAbility(user: memberPosition, ability: ability), at: Date())
            }
        ]
    }

    private func drawHPBar(currentHP: Int, maxHP: Int, position: Vector2) -> [any GUIDrawable] {
        var result = [any GUIDrawable]()

        // label:
        result.append(GUIText(font: fontsizes[16], position: position, text: "HP: ", color: .white))

        // outer bar:
        result.append(
            GUIRectangle(
                position: position + Vector2(x: 30, y: 0), size: Vector2(x: 145, y: 15),
                color: .white))

        // inner bar:
        let maxWidth: Float = 145 - 4
        let size = Float(currentHP) / Float(maxHP) * maxWidth

        result.append(
            GUIRectangle(
                position: position + Vector2(x: 30 + 2, y: 2), size: Vector2(x: size, y: 15 - 4),
                color: hpBarColor(currentHP: currentHP, maxHP: maxHP)))

        return result
    }
}
