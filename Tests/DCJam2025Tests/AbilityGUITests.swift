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
            let drawables = gui.draw()
            
            let buttons = drawables.buttons(groupingID: "Abilities")
            
            #expect(buttons.contains(where: { $0.text == "y" } ) == false)
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
            let abilityButton = try #require(gui.draw().buttons(groupingID: "Abilities")
                .first(where: { $0.text == "(2)" })
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
            
            let abilityButton = gui.draw().buttons(groupingID: "Abilities")
                .first(where: { $0.text == "(2)" })
                        
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
            let componentButton = try #require(gui.draw().buttons(groupingID: "AvailableAbilities")
                .first(where: { $0.text == "r" })
            )
                        
            componentButton.tap()
            
            let drawables = gui.draw()
            
            let buttons = drawables.buttons(groupingID: "Abilities")
            #expect(buttons.contains(where: { $0.text == "r" } ))
        }
    }
}
