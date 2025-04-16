//
//  VizualizationTests.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

import Testing
import Raylib
@testable import DCJam2025

@Suite("Converting between game logic structures and visual representations should") struct ConversionGameLogicAndVizualizationTests {
    
    @Test("return the expected position for specific testcases", arguments: [
        (Coordinate(x: 9, y: 0), Vector3(x: 9.0, y: 0.0, z: 0.0)),
        (Coordinate(x: -3, y: 5), Vector3(x: -3.0, y: 0.0, z: 5.0)),
        (Coordinate(x: 6, y: 6), Vector3(x: 6.0, y: 0.0, z: 6.0)),
        (Coordinate(x: 0, y: 7), Vector3(x: 0.0, y: 0.0, z: 7.0)),
        (Coordinate(x: 10, y: 4), Vector3(x: 10.0, y: 0.0, z: 4.0)),
        (Coordinate(x: -3, y: -3), Vector3(x: -3.0, y: 0.0, z: -3.0)),
        (Coordinate(x: 8, y: 9), Vector3(x: 8.0, y: 0.0, z: 9.0)),
        (Coordinate(x: 10, y: 6), Vector3(x: 10.0, y: 0.0, z: 6.0)),
        (Coordinate(x: -3, y: -9), Vector3(x: -3.0, y: 0.0, z: -9.0)),
        (Coordinate(x: -5, y: 1), Vector3(x: -5.0, y: 0.0, z: 1.0)),
        (Coordinate(x: -7, y: 9), Vector3(x: -7.0, y: 0.0, z: 9.0)),
        (Coordinate(x: -6, y: -1), Vector3(x: -6.0, y: 0.0, z: -1.0)),
        (Coordinate(x: -5, y: -4), Vector3(x: -5.0, y: 0.0, z: -4.0)),
        (Coordinate(x: -8, y: 10), Vector3(x: -8.0, y: 0.0, z: 10.0)),
        (Coordinate(x: -2, y: -1), Vector3(x: -2.0, y: 0.0, z: -1.0)),
        (Coordinate(x: -3, y: 3), Vector3(x: -3.0, y: 0.0, z: 3.0)),
        (Coordinate(x: -1, y: 10), Vector3(x: -1.0, y: 0.0, z: 10.0)),
        (Coordinate(x: 9, y: -6), Vector3(x: 9.0, y: 0.0, z: -6.0)),
        (Coordinate(x: 7, y: 4), Vector3(x: 7.0, y: 0.0, z: 4.0)),
        (Coordinate(x: 6, y: -5), Vector3(x: 6.0, y: 0.0, z: -5.0)),
    ]) func convertingBetweenGameLogicPositionAndRotationAndVizualization(testcase: (position: Coordinate, expectedPosition: Vector3)) {
        #expect(testcase.position.toVector3.x == testcase.expectedPosition.x)
        #expect(testcase.position.toVector3.y == testcase.expectedPosition.y)
        #expect(testcase.position.toVector3.z == testcase.expectedPosition.z)
    }
    
    @Test("return the expected forward vector for specific testcases", arguments: [
        (Coordinate(x: 6, y: 10), CompassDirection.west, Coordinate(x: 5, y: 10)),
        (Coordinate(x: -10, y: -2), CompassDirection.west, Coordinate(x: -11, y: -2)),
        (Coordinate(x: -1, y: 7), CompassDirection.north, Coordinate(x: -1, y: 8)),
        (Coordinate(x: -5, y: 10), CompassDirection.south, Coordinate(x: -5, y: 9)),
        (Coordinate(x: 7, y: -7), CompassDirection.south, Coordinate(x: 7, y: -8)),
        (Coordinate(x: -5, y: 6), CompassDirection.west, Coordinate(x: -6, y: 6)),
        (Coordinate(x: -5, y: 2), CompassDirection.north, Coordinate(x: -5, y: 3)),
        (Coordinate(x: 6, y: -1), CompassDirection.west, Coordinate(x: 5, y: -1)),
        (Coordinate(x: 2, y: -1), CompassDirection.west, Coordinate(x: 1, y: -1)),
        (Coordinate(x: 5, y: 5), CompassDirection.north, Coordinate(x: 5, y: 6)),
        (Coordinate(x: -9, y: -6), CompassDirection.south, Coordinate(x: -9, y: -7)),
        (Coordinate(x: -10, y: 3), CompassDirection.west, Coordinate(x: -11, y: 3)),
        (Coordinate(x: 2, y: -7), CompassDirection.west, Coordinate(x: 1, y: -7)),
        (Coordinate(x: -8, y: -10), CompassDirection.east, Coordinate(x: -7, y: -10)),
        (Coordinate(x: -8, y: 0), CompassDirection.east, Coordinate(x: -7, y: 0)),
        (Coordinate(x: 0, y: 6), CompassDirection.east, Coordinate(x: 1, y: 6)),
        (Coordinate(x: 8, y: 8), CompassDirection.north, Coordinate(x: 8, y: 9)),
        (Coordinate(x: 10, y: -2), CompassDirection.west, Coordinate(x: 9, y: -2)),
        (Coordinate(x: -10, y: -1), CompassDirection.south, Coordinate(x: -10, y: -2)),
        (Coordinate(x: 10, y: -6), CompassDirection.south, Coordinate(x: 10, y: -7)),
    ])
    func convertingBetweenGameLogicCreatesCorrectTargetPosition(testcase: (position: Coordinate, heading: CompassDirection, expectedTargetPosition: Coordinate)) {
        #expect(target(from: testcase.position, heading: testcase.heading) == testcase.expectedTargetPosition)
    }
    
    @Test("Calculate the correct amount of light of a coordinate, when viewed from a specific coordinate", arguments: [
        (Coordinate(x: 10, y: 10), Coordinate(x: -3, y: 4), Float(0.069843024)),
        (Coordinate(x: 4, y: 0), Coordinate(x: 3, y: 0), Float(1.0)),
        (Coordinate(x: -1, y: 8), Coordinate(x: -3, y: 0), Float(0.12126782)),
        (Coordinate(x: -9, y: -9), Coordinate(x: -2, y: -3), Float(0.10846523)),
        (Coordinate(x: 7, y: 2), Coordinate(x: 4, y: 4), Float(0.2773501)),
        (Coordinate(x: -10, y: 10), Coordinate(x: 0, y: -4), Float(0.05812382)),
        (Coordinate(x: -8, y: 8), Coordinate(x: 4, y: 4), Float(0.07905694)),
        (Coordinate(x: 9, y: -3), Coordinate(x: -1, y: 4), Float(0.081923194)),
        (Coordinate(x: 1, y: -10), Coordinate(x: 4, y: 1), Float(0.0877058)),
        (Coordinate(x: 4, y: -3), Coordinate(x: 2, y: -1), Float(0.35355338)),
        (Coordinate(x: 8, y: 7), Coordinate(x: -1, y: -2), Float(0.078567415)),
        (Coordinate(x: -10, y: 7), Coordinate(x: 0, y: 3), Float(0.09284767)),
        (Coordinate(x: 5, y: 4), Coordinate(x: 2, y: -2), Float(0.1490712)),
        (Coordinate(x: -9, y: -10), Coordinate(x: -2, y: 0), Float(0.081923194)),
        (Coordinate(x: -8, y: 8), Coordinate(x: 3, y: -3), Float(0.06428244)),
        (Coordinate(x: -10, y: 10), Coordinate(x: 3, y: -1), Float(0.058722023)),
        (Coordinate(x: 0, y: 0), Coordinate(x: -3, y: 2), Float(0.2773501)),
        (Coordinate(x: -5, y: 5), Coordinate(x: 1, y: -3), Float(0.1)),
        (Coordinate(x: -1, y: 1), Coordinate(x: 4, y: 3), Float(0.18569534)),
        (Coordinate(x: 7, y: 8), Coordinate(x: 2, y: 3), Float(0.14142136)),
    ]) func testLightCalculation(testcase: (position: Coordinate, vantagePoint: Coordinate, expectedLight: Float)) {
        #expect(light(position: testcase.position, vantagePoint: testcase.vantagePoint) == testcase.expectedLight)
    }
}
