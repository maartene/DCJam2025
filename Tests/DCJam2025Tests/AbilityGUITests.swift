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
    let partyMember = PartyMember.makeMage(name: "Example Partymember", position: .backRight)
    
    @Test("contain buttons for all the abilities the game knows about") func showAllAbilities() {
        let gui = AbilityGUI(sprites: [:], fontsizes: [:], partyMember: partyMember, viewModel: AbilityGUIViewModel())
        
        let drawables = gui.draw()
        
        let buttons = drawables.buttons(groupingID: "AvailableAbilities")
        
        #expect(buttons.count == allAbilities().count)
        
        for ability in allAbilities() {
            #expect(buttons.contains(where: { $0.text == ability.key } ))
        }
    }
    
    @Suite("when no ability is selected") struct NoAbilitySelected {
        let partyMember = PartyMember.makeMage(name: "Example Partymember", position: .backRight)
        
        @Test("all the 'available ability' buttons should be disabled") func allAvailabilityButtonsAreDisabled() {
            let gui = AbilityGUI(sprites: [:], fontsizes: [:], partyMember: partyMember, viewModel: AbilityGUIViewModel())
            
            let drawables = gui.draw()
            
            let buttons = drawables.buttons(groupingID: "AvailableAbilities")

            #expect(buttons.count == allAbilities().count)
            
            buttons.forEach {
                #expect($0.enabled == false)
            }
        }
        
        @Test("there should be no selection bare on the screen") func noSelectionBar() {
            let gui = AbilityGUI(sprites: [:], fontsizes: [:], partyMember: partyMember, viewModel: AbilityGUIViewModel())
            
            let drawables = gui.draw()
            
            let rectangles = drawables.rectangles(groupingID: "Abilities")
            
            #expect(rectangles.isEmpty)
            
        }
    }
}
