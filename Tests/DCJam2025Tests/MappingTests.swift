//
//  MappingTests.swift
//  DCJam2025
//
//  Created by Maarten Engels on 14/04/2025.
//

import Testing
@testable import DCJam2025

@Suite("The party should keep track of the tiles it found") struct MappingTests {
    @Test("When the world is created, the party only knows about their direct surroundings") func newWorldMap() {
        let world = World(map: Floor())

        let expectedVisitedTiles: Set = [
            Coordinate(x: -1, y: -1),
            Coordinate(x: 0, y: -1),
            Coordinate(x: 1, y: -1),
            Coordinate(x: -1, y: 0),
            Coordinate(x: 0, y: 0),
            Coordinate(x: 1, y: 0),
            Coordinate(x: -1, y: 1),
            Coordinate(x: 0, y: 1),
            Coordinate(x: 1, y: 1)
        ]

        #expect(world.visitedTilesOnCurrentFloor == expectedVisitedTiles)
    }

    @Test("When the party moves, new tiles added to the visited world") func newTilesVisited() {
        let world = World(map: Floor())
        world.moveParty(.right)

        let expectedVisitedTiles: Set = [
            Coordinate(x: -1, y: -1),
            Coordinate(x: 0, y: -1),
            Coordinate(x: 1, y: -1),
            Coordinate(x: -1, y: 0),
            Coordinate(x: 0, y: 0),
            Coordinate(x: 1, y: 0),
            Coordinate(x: -1, y: 1),
            Coordinate(x: 0, y: 1),
            Coordinate(x: 1, y: 1),
            Coordinate(x: 2, y: -1),
            Coordinate(x: 2, y: 0),
            Coordinate(x: 2, y: 1)
        ]

        #expect(world.visitedTilesOnCurrentFloor == expectedVisitedTiles)
    }

    @Test("When the party visits a new floor, the visited tiles are reset") func visitedTilesResetOnNewFloor() {
        let world = World(floors: [
            Floor([
                [".", ".", ",", "<"]
            ]),
            Floor([
                [".", ".", ".", ">"]
            ])
        ])

        world.moveParty(.right)
        world.moveParty(.right)

        let vistedTilesOnFloor1 = world.visitedTilesOnCurrentFloor.count

        world.moveParty(.right)

        #expect(world.visitedTilesOnCurrentFloor.count < vistedTilesOnFloor1)
    }
}
