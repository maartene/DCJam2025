//
//  ImportWorldTests.swift
//  DCJam2025
//
//  Created by Maarten Engels on 12/04/2025.
//

import Testing
@testable import DCJam2025

@Suite("Creating a new world from a set of floorplans should") struct ImportWorldTests {
    @Test("Create a world with a single floor when a single floorplan is provided") func singleFloorWorld() {
        let floorplan =
        """
        ####
        # S#
        ####
        """
        
        let world = makeWorld(from: [floorplan])
        
        let expectedWorld = World(floors: [
            Floor([
                ["#","#","#","#"],
                ["#"," "," ","#"],
                ["#","#","#","#"],
            ])
        ], partyStartPosition: Coordinate(x: 2, y: 1))
        
        #expect(world == expectedWorld)
    }
}
