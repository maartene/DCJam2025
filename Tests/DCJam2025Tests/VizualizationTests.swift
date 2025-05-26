//
//  VizualizationTests.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

import Testing
import raylib
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
        (Coordinate(x: 6, y: -5), Vector3(x: 6.0, y: 0.0, z: -5.0))
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
        (Coordinate(x: 10, y: -6), CompassDirection.south, Coordinate(x: 10, y: -7))
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
        (Coordinate(x: 7, y: 8), Coordinate(x: 2, y: 3), Float(0.14142136))
    ]) func testLightCalculation(testcase: (position: Coordinate, vantagePoint: Coordinate, expectedLight: Float)) {
        #expect(light(position: testcase.position, vantagePoint: testcase.vantagePoint) == testcase.expectedLight)
    }

    @Test("Maximize the amount of light to 1 if vantage point and coordiante are the same") func maxLightCalculation() {
        let position = Coordinate(x: 10, y: 15)
        #expect(light(position: position, vantagePoint: position) == 1)
    }

    @Test("Calculate the multiple of a color and a scalar", arguments: [
        (Color(r: 255, g: 255, b: 255, a: 255), Float(0.5), Color(r: 127, g: 127, b: 127, a: 255)),
        (Color(r: 113, g: 194, b: 157, a: 255), Float(0.8371812), Color(r: 94, g: 162, b: 131, a: 255)),
        (Color(r: 127, g: 11, b: 14, a: 255), Float(0.9392248), Color(r: 119, g: 10, b: 13, a: 255)),
        (Color(r: 211, g: 64, b: 139, a: 255), Float(0.83148295), Color(r: 175, g: 53, b: 115, a: 255)),
        (Color(r: 251, g: 237, b: 238, a: 255), Float(0.67156947), Color(r: 168, g: 159, b: 159, a: 255)),
        (Color(r: 25, g: 137, b: 218, a: 255), Float(0.3642103), Color(r: 9, g: 49, b: 79, a: 255)),
        (Color(r: 252, g: 38, b: 182, a: 255), Float(0.12794071), Color(r: 32, g: 4, b: 23, a: 255)),
        (Color(r: 15, g: 88, b: 253, a: 255), Float(0.80421245), Color(r: 12, g: 70, b: 203, a: 255)),
        (Color(r: 39, g: 75, b: 217, a: 255), Float(0.57205117), Color(r: 22, g: 42, b: 124, a: 255)),
        (Color(r: 65, g: 90, b: 26, a: 255), Float(0.36239207), Color(r: 23, g: 32, b: 9, a: 255)),
        (Color(r: 4, g: 24, b: 116, a: 255), Float(0.38090336), Color(r: 1, g: 9, b: 44, a: 255))
    ]) func multiplyColorWithScalar(testcase: (color: Color, scalar: Float, expectedColor: Color)) {
        let multipliedColor = testcase.color * testcase.scalar
        #expect(multipliedColor.r == testcase.expectedColor.r)
        #expect(multipliedColor.g == testcase.expectedColor.g)
        #expect(multipliedColor.b == testcase.expectedColor.b)
    }

    @Test("Multiplying a color with a scalar does not change its alpha value") func multiplyingColorDoesNotChangeAlpha() {
        #expect((Color.blue * 0.1).a == 255)
        #expect((Color(r: 123, g: 34, b: 57, a: 100) * 0.3).a == 100)
    }
}

@Suite("Minimap conversions") struct MinimapConversions {
    @Test("Determine sprite and screen position for tiles", arguments: [
        (Coordinate(x: 1, y: 0), Int32(-20), Int32(-99), "wall", Int32(28), Int32(-51)),
        (Coordinate(x: 1, y: 2), Int32(15), Int32(11), "stairsDown", Int32(63), Int32(27)),
        (Coordinate(x: 3, y: 2), Int32(87), Int32(-76), "stairsUp", Int32(103), Int32(-60))
    ]) func spriteAndScreenPositionForTiles(testcase: (position: Coordinate, xOffset: Int32, yOffset: Int32, expectedSpriteName: String, expectedScreenX: Int32, expectedScreenY: Int32)) {
        let floor = Floor([
            ["#", "#", "#", "#", "#"],
            ["#", ".", ".", ".", "#"],
            ["#", ">", ".", "<", "#"],
            ["#", "#", "#", "#", "#"]
        ])

        let coordinates = [
            Coordinate(x: 1, y: 0),
            Coordinate(x: 1, y: 2),
            Coordinate(x: 3, y: 2)
        ]

        for coordinate in coordinates {
            let xOffset = Int32.random(in: -100...100)
            let yOffset = Int32.random(in: -100...100)
            let info = getSpriteAndPositionForTileAtPosition(coordinate, on: floor, offsetX: xOffset, offsetY: yOffset)

            print("(Coordinate(x: \(coordinate.x), y: \(coordinate.y)), Int32(\(xOffset)), Int32(\(yOffset)), \"\(info.spriteName)\", Int32(\(info.displayX)), Int32(\(info.displayY)),")
        }

        let tileSpriteInfo = getSpriteAndPositionForTileAtPosition(testcase.position, on: floor, offsetX: testcase.xOffset, offsetY: testcase.yOffset)
        #expect(tileSpriteInfo.spriteName == testcase.expectedSpriteName)
        #expect(tileSpriteInfo.displayX == testcase.expectedScreenX)
        #expect(tileSpriteInfo.displayY == testcase.expectedScreenY)
    }

    @Test("Determine sprite and screen position for party", arguments: [
        (Coordinate(x: 1, y: 0), CompassDirection.north, Int32(-20), Int32(-99), "north", Int32(28), Int32(-51)),
        (Coordinate(x: 1, y: 2), CompassDirection.south, Int32(15), Int32(11), "south", Int32(63), Int32(27)),
        (Coordinate(x: 3, y: 2), CompassDirection.west, Int32(87), Int32(-76), "east", Int32(103), Int32(-60)),
        (Coordinate(x: 3, y: 2), CompassDirection.east, Int32(87), Int32(-76), "west", Int32(103), Int32(-60))
    ]) func spriteAndScreenPositionForParty(testcase: (position: Coordinate, heading: CompassDirection, xOffset: Int32, yOffset: Int32, expectedSpriteName: String, expectedScreenX: Int32, expectedScreenY: Int32)) {
        let floor = Floor([
            ["#", ".", ".", ".", "#"],
            ["#", ".", ".", ".", "#"],
            ["#", ".", ".", ".", "#"],
            ["#", ".", ".", ".", "#"]
        ])

        let partySpriteInfo = getSpriteAndPositionForPartyAtPosition(testcase.position, heading: testcase.heading, on: floor, offsetX: testcase.xOffset, offsetY: testcase.yOffset)
        #expect(partySpriteInfo.spriteName == testcase.expectedSpriteName)
        #expect(partySpriteInfo.displayX == testcase.expectedScreenX)
        #expect(partySpriteInfo.displayY == testcase.expectedScreenY)
    }
}
