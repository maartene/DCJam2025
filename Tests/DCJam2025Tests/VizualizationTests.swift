//
//  VizualizationTests.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

import Testing
import raylib
@testable import DCJam2025
import Model

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
    
    @Test("Determine the color of HP bar", arguments: [
        (100, 100, Color.green),
        (50, 100, .green),
        (30, 100, .yellow),
        (10, 100, .red),
        (0, 100, .red),
        (10, 10, .green),
        (50, 10, .green),
        (3, 10, .yellow),
        (1, 10, .red),
        (0, 10, .red)
    ]) func determineHPBarColor(testcase: (currentHP: Int, maxHP: Int, expectedColor: Color)) {
        #expect(hpBarColor(currentHP: testcase.currentHP, maxHP: testcase.maxHP) == testcase.expectedColor)
    }
}

@Suite("Minimap conversions") struct MinimapConversions {
    @Test("Determine sprite and screen position for tiles", arguments: [
        (Coordinate(x: 1, y: 0), Int32(-20), Int32(-99), "wall", Vector2(x: 28, y: -51)),
        (Coordinate(x: 1, y: 2), Int32(15), Int32(11), "stairsDown", Vector2(x: 63, y: 27)),
        (Coordinate(x: 3, y: 2), Int32(87), Int32(-76), "stairsUp", Vector2(x: 103, y: -60))
    ]) func spriteAndScreenPositionForTiles(testcase: (position: Coordinate, xOffset: Int32, yOffset: Int32, expectedSpriteName: String, expectedScreen: Vector2)) {
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

//        for coordinate in coordinates {
//            let xOffset = Int32.random(in: -100...100)
//            let yOffset = Int32.random(in: -100...100)
//            let info = getSpriteAndPositionForTileAtPosition(coordinate, on: floor, offsetX: xOffset, offsetY: yOffset)
//
////            print("(Coordinate(x: \(coordinate.x), y: \(coordinate.y)), Int32(\(xOffset)), Int32(\(yOffset)), \"\(info.spriteName)\", Int32(\(info.displayX)), Int32(\(info.displayY)),")
//        }

        let tileSpriteInfo = getSpriteAndPositionForTileAtPosition(testcase.position, on: floor, offsetX: testcase.xOffset, offsetY: testcase.yOffset)
        #expect(tileSpriteInfo.spriteName == testcase.expectedSpriteName)
        #expect(tileSpriteInfo.position == testcase.expectedScreen)
        //#expect(tileSpriteInfo.displayY == testcase.expectedScreenY)
    }

    @Test("Determine sprite and screen position for party", arguments: [
        (Coordinate(x: 1, y: 0), CompassDirection.north, Int32(-20), Int32(-99), "north", Vector2(x: 28, y: -51)),
        (Coordinate(x: 1, y: 2), CompassDirection.south, Int32(15), Int32(11), "south", Vector2(x: 63, y: 27)),
    (Coordinate(x: 3, y: 2), CompassDirection.west, Int32(87), Int32(-76), "east", Vector2(x: 103, y: -60)),
    (Coordinate(x: 3, y: 2), CompassDirection.east, Int32(87), Int32(-76), "west", Vector2(x: 103, y:-60))
    ]) func spriteAndScreenPositionForParty(testcase: (position: Coordinate, heading: CompassDirection, xOffset: Int32, yOffset: Int32, expectedSpriteName: String, expectedScreen: Vector2)) {
        let floor = Floor([
            ["#", ".", ".", ".", "#"],
            ["#", ".", ".", ".", "#"],
            ["#", ".", ".", ".", "#"],
            ["#", ".", ".", ".", "#"]
        ])

        let partySpriteInfo = getSpriteAndPositionForEntityAtPosition(testcase.position, heading: testcase.heading, on: floor, offsetX: testcase.xOffset, offsetY: testcase.yOffset)
        #expect(partySpriteInfo.spriteName == testcase.expectedSpriteName)
        #expect(partySpriteInfo.position == testcase.expectedScreen)
    }
}

@Suite("Map conversions") struct MapConversionTests {
    @Test("convert a map into drawables") func convertAMapIntoDrawables() {
        let floor = Floor([
            ["#", ".", ".", "#"],
            ["#", "S", ">", "#"],
            ["#", "<", "T", "#"]
        ])
        
        let expectedDrawables = [
            Drawable3D(modelName: "wall", position: Vector3(x: 0.0, y: 0.0, z: 0.0), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 0.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
            Drawable3D(modelName: "floor_wood_large", position: Vector3(x: 1.0, y: -0.5, z: 0.0), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 0.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
            Drawable3D(modelName: "ceiling_tile", position: Vector3(x: 1.0, y: 0.5, z: 0.0), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 0.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
            Drawable3D(modelName: "floor_wood_large", position: Vector3(x: 2.0, y: -0.5, z: 0.0), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 0.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
            Drawable3D(modelName: "ceiling_tile", position: Vector3(x: 2.0, y: 0.5, z: 0.0), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 0.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
            Drawable3D(modelName: "wall", position: Vector3(x: 3.0, y: 0.0, z: 0.0), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 0.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
            Drawable3D(modelName: "wall", position: Vector3(x: 0.0, y: 0.0, z: 1.0), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 0.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
            Drawable3D(modelName: "floor_wood_large", position: Vector3(x: 1.0, y: -0.5, z: 1.0), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 0.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
            Drawable3D(modelName: "ceiling_tile", position: Vector3(x: 1.0, y: 0.5, z: 1.0), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 0.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
            Drawable3D(modelName: "stairs", position: Vector3(x: 2.0, y: -1.5, z: 1.5), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 180.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
            Drawable3D(modelName: "ceiling_tile", position: Vector3(x: 2.0, y: 0.5, z: 1.0), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 0.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
            Drawable3D(modelName: "wall", position: Vector3(x: 3.0, y: 0.0, z: 1.0), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 0.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
            Drawable3D(modelName: "wall", position: Vector3(x: 0.0, y: 0.0, z: 2.0), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 0.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
            Drawable3D(modelName: "stairs", position: Vector3(x: 1.0, y: -0.5, z: 2.5), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 180.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
            Drawable3D(modelName: "floor_wood_large", position: Vector3(x: 2.0, y: -0.5, z: 2.0), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 0.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
            Drawable3D(modelName: "ceiling_tile", position: Vector3(x: 2.0, y: 0.5, z: 2.0), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 0.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
            Drawable3D(modelName: "wall", position: Vector3(x: 3.0, y: 0.0, z: 2.0), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 0.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
            Drawable3D(modelName: "chest_gold", position: Vector3(x: 2.0, y: -0.5, z: 2.0), up: Vector3(x: 0.0, y: 1.0, z: 0.0), rotation: 180.0, tint: Color(r: 255, g: 255, b: 255, a: 255), scale: Vector3(x: 0.25, y: 0.25, z: 0.25)),
        ]
        
        let drawables = floorToDrawables(floor)
        
        #expect(drawables.count == expectedDrawables.count)
        for drawable in drawables {
            #expect(expectedDrawables.contains(drawable))
        }
    }
    
    @Test("convert an enemy into a drawable") func convertEnemyIntoDrawables() {
        let enemy = Enemy.makeRangedEnemy(at: Coordinate(x: 12, y: 95))
        
        let expectedDrawable = Drawable3D(modelName: "Skeleton_Warrior", position: Vector3(x: 12, y: -0.5, z: 95), up: .up, rotation: 270, tint: .white, scale: .one.scale(0.5))
        
        let drawable = Drawable3D.makeEntity(enemy)
        
        #expect(drawable == expectedDrawable)
    }
}
