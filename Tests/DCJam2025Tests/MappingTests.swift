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
            Coordinate(x: 1, y: 1),
        ]
        
        #expect(world.visitedTilesOnCurrentFloor == expectedVisitedTiles)
    }
}
