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
                ["#", "#", "#", "#"],
                ["#", " ", " ", "#"],
                ["#", "#", "#", "#"]
            ])
        ], partyStartPosition: Coordinate(x: 2, y: 1))

        #expect(world == expectedWorld)
    }

    @Test("Create a world with a multiple floors when more than one floorplan is provided") func multipleFloorWorld() {
        let floorplan1 =
        """
        #####
        #...#
        #.S<#
        #...#
        #####
        """

        let floorplan2 =
        """
        #####
        #...#
        #.#>#
        #...#
        #####
        """

        let world = makeWorld(from: [floorplan1, floorplan2])

        let expectedWorld = World(floors: [
            Floor([
                ["#", "#", "#", "#", "#"],
                ["#", ".", ".", ".", "#"],
                ["#", ".", ".", "<", "#"],
                ["#", ".", ".", ".", "#"],
                ["#", "#", "#", "#", "#"]
            ]),
            Floor([
                ["#", "#", "#", "#", "#"],
                ["#", ".", ".", ".", "#"],
                ["#", ".", "#", ">", "#"],
                ["#", ".", ".", ".", "#"],
                ["#", "#", "#", "#", "#"]
            ])
        ], partyStartPosition: Coordinate(x: 2, y: 2), enemies: [[],[]])

        #expect(world == expectedWorld)
    }

    @Test("When no start tile is passed in in a floor, it is assumed to be at (0,0)") func assumeStartPosition() {
        let floorplan =
        """
        ...
        ...
        """

        let world = makeWorld(from: [floorplan])

        #expect(world.partyPosition == Coordinate(x: 0, y: 0))
    }

    @Test("A floor can be converted back to its string representations") func floorDescriptionIsStringRepresentation() {
        let floorplan =
        """
        #####
        #...#
        #..<#
        #...#
        #####
        """

        let world = makeWorld(from: [floorplan])

        #expect(world.currentFloor.description == floorplan)
    }
    
    @Test("Enemies are bound to the floor they are placed on") func enemiesAreBoundToAFloor() {
        let world = makeWorld(from: [
            ".<s",
            ".."
            ])
        
        #expect(world.enemiesOnCurrentFloor.isEmpty == false)
        
        world.moveParty(.right)
        
        #expect(world.enemiesOnCurrentFloor.isEmpty)
    }
}
