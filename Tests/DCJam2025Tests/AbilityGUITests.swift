//
//  AbilityGUITests.swift
//  DCJam2025
//
//  Created by Maarten Engels on 08/09/2025.
//

import Testing
@testable import DCJam2025
import Model

@Suite("The AbilityGUI should") struct AbilityGUITests {
    @Suite("regardless of whether an ability is selected") struct RegardlessOfSelection {
        let partyMember: PartyMember
        let gui: AbilityGUI
        
        init() {
            partyMember = PartyMember.makeMage(name: "Example Partymember", position: .backRight)
            gui = AbilityGUI(sprites: [:], fontsizes: [:], partyMember: partyMember)
        }
        
        @Test("contain buttons for all the abilities the game knows about") func showAllAbilities() {
            let drawables = gui.draw()
            
            let buttons = drawables.buttons(groupingID: "AvailableAbilities")
            
            #expect(buttons.count == allAbilities().count)
            
            for ability in allAbilities() {
                #expect(buttons.contains(where: { $0.text == ability.key } ))
            }
        }
        
        @Test("show all the party members' abilities") func showAllPartyMemberAbilities() {
            let drawables = gui.draw()
            
            let buttons = drawables.buttons(groupingID: "Abilities")
            
            for i in 0 ..< partyMember.abilities.count {
                #expect(buttons.contains(where: { $0.text == "(\(i + 1))" } ))
            }
        }
        
        @Test("shows all the components of a party members ability") func showAllAbilityComponents() {
            let drawables = gui.draw()
            
            let buttons = drawables.buttons(groupingID: "Abilities")
            
            let expectedComponents = ["a", "h", "x"]
            
            expectedComponents.forEach { component in
                #expect(buttons.contains(where: { $0.text == component } ))
            }
        }
        
        @Test("does not show components that are not in an ability") func doesNotShowMissingComponents() {
            #expect(getButton("y", from: gui.draw(), groupingID: "Abilities") == nil)
        }
        
        @Test("when a component is clicked, its removed from the ability") func removeComponent() throws {
            let componentButton = try #require(
                getButton("h", from: gui.draw(), groupingID: "Abilities")
            )
                        
            componentButton.tap()
            
            #expect(getButton("h", from: gui.draw(), groupingID: "Abilities") == nil)
            #expect(partyMember.abilities.contains(where: { $0.key.contains("h") } ) == false)
        }
        
        @Test("should show a 'Remove ability' button") func showRemoveAbilityButton() {
            #expect(getButton("-", from: gui.draw(), groupingID: "Abilities") != nil)
        }
        
        @Test("should remove the ability when the Remove ability button is clicked") func removeAbilityButtonClicked() throws {
            let componentButton = try #require(
                getButton("-", from: gui.draw(), groupingID: "Abilities")
            )
                        
            componentButton.tap()
            
            let drawables = gui.draw()
            
            let buttons = drawables.buttons(groupingID: "Abilities")
            
            #expect(buttons.filter({ $0.text == "-" }).count == 1)
            #expect(partyMember.abilities.count == 1)
        }
        
        @Test("should show an Add ability button") func showAddAbilityButton() {
            #expect(getButton("Add ability", from: gui.draw(), groupingID: "Abilities") != nil)
        }
        
        @Test("when the 'Add ability' button is clicked, should add a new ability") func addAbilityButtonClicked() throws {
            let addAbilityButton = try #require(
                getButton("Add ability", from: gui.draw(), groupingID: "Abilities")
            )
                        
            addAbilityButton.tap()
            
            #expect(getButton("(3)", from: gui.draw(), groupingID: "Abilities") != nil)
            #expect(partyMember.abilities.count == 3)
        }
        
        @Test("should show a close button") func showCloseButton() {
            #expect(getButton("X", from: gui.draw(), groupingID: "Window") != nil)
        }
        
        @Test("should hide gui when close button is clicked") func closeButtonClicked() throws {
            let closeButton = try #require(getButton("X", from: gui.draw(), groupingID: "Window"))
            
            closeButton.tap()
            
            #expect(gui.draw().isEmpty)
        }
    }
    
    @Suite("when no ability is selected") struct NoAbilitySelected {
        let partyMember: PartyMember
        let gui: AbilityGUI
        
        init() {
            partyMember = PartyMember.makeMage(name: "Example Partymember", position: .backRight)
            gui = AbilityGUI(sprites: [:], fontsizes: [:], partyMember: partyMember)
        }
        
        @Test("all the 'available ability' buttons should be disabled") func allAvailabilityButtonsAreDisabled() {
            let drawables = gui.draw()
            
            let buttons = drawables.buttons(groupingID: "AvailableAbilities")

            #expect(buttons.count == allAbilities().count)
            
            buttons.forEach {
                #expect($0.enabled == false)
            }
        }
        
        @Test("there should be no selection bar on the screen") func noSelectionBar() {
            let drawables = gui.draw()
            
            let rectangles = drawables.rectangles(groupingID: "Abilities")
            
            #expect(rectangles.isEmpty)
            
        }
        
        @Test("when an ability is pressed, the selection bar should appear") func selectAnAbility() throws {
            let abilityButton = try #require(
                getButton("(2)", from: gui.draw(), groupingID: "Abilities")
            )
                        
            abilityButton.tap()
                
            let rectangles = gui.draw().rectangles(groupingID: "Abilities")

            #expect(rectangles.isEmpty == false)
        }
    }
    
    @Suite("when an ability is selected") struct AbilitySelected {
        let partyMember: PartyMember
        let gui: AbilityGUI
        
        init() {
            partyMember = PartyMember.makeMage(name: "Example Partymember", position: .backRight)
            gui = AbilityGUI(sprites: [:], fontsizes: [:], partyMember: partyMember)
            
            let abilityButton = getButton("(2)", from: gui.draw(), groupingID: "Abilities")
                        
            abilityButton?.tap()
        }
        
        @Test("all the 'available ability' buttons should be enabled") func allAvailableAbilityButtonsShouldBeEnabled() {
            let drawables = gui.draw()
            
            let buttons = drawables.buttons(groupingID: "AvailableAbilities")

            #expect(buttons.count == allAbilities().count)
            
            buttons.forEach {
                #expect($0.enabled == true)
            }
        }
        
        @Test("and an available ability is clicked, its added to the selected ability") func addComponentToSelectedAbility() throws {
            let componentButton = try #require(
                getButton("r", from: gui.draw(), groupingID: "AvailableAbilities")
            )
                        
            componentButton.tap()
            
            #expect(getButton("r", from: gui.draw(), groupingID: "Abilities") != nil)
            #expect(partyMember.abilities.contains(where: { $0.key.contains("r")} ))
        }
        
        @Test("should show a tooltip when hovering over a component") func showTooltip() throws {
                let drawables = gui.draw()
                
                #expect(getTooltip(from: drawables) != nil)
        }
    }
}

fileprivate func getButton(_ name: String, from drawables: [GUIDrawable], groupingID: String) -> GUIButton? {
    drawables.buttons(groupingID: groupingID)
        .first(where: { $0.text == name })
}

fileprivate func getTooltip(from drawables: [GUIDrawable]) -> String? {
    drawables.compactMap { $0 as? GUIText }
        .first(where: { $0.groupingID == "Tooltip" } )?
        .text
}
