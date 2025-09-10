//
//  AbilityGUISnapshotTests.swift
//  DCJam2025
//
//  Created by Engels, Maarten MAK on 10/09/2025.
//

import Testing
import SnapshotTesting
@testable import DCJam2025
import Model

@Suite("GUI snapshots") struct GUISnapShots {
    @Test("AbilityGUI snapshot")
    func abilityGUISnapshot() async throws {
        let partyMember = PartyMember.makeMeleePartyMember(name: "Louise", position: .frontRight)
        let abilityGUI = AbilityGUI(sprites: [:], fontsizes: [:], partyMember: partyMember)
        
        let drawables = abilityGUI.draw()
        
        assertSnapshot(of: drawables, as: .dump)
    }
    
    @Test("GUI snapshot")
    func guiSnapshot() async throws {
        let world = World(floors: [Floor()])
        let gui = GUI(world: world, sprites: [:], fontsizes: [:])
        
        
        let drawables = gui.drawParty()
        
        assertSnapshot(of: drawables, as: .dump)
    }
}

@Suite("Minimap snapshots") struct MinimapSnapshots {
    @Test("Minimap snapshot") func minimapSnapshot() {
        let world = makeWorld(from: [
            """
            .S<
            T>.
            #.s
            """
        ])
        
        let drawables = Set(minimap(for: world))
        
        assertSnapshot(of: drawables, as: .dump)
    }
}

@Suite("3D map snapshots") struct Map3DSnapshots {
    @Test("3D map snapshot") func map3DSnapshot() {
        let floor = Floor([
            ["#", ".", ".", "#"],
            ["#", "S", ">", "#"],
            ["#", "<", "T", "#"],
        ])
        
        let drawables = Set(floorToDrawables(floor))
        
        assertSnapshot(of: drawables, as: .dump)
    }
}
