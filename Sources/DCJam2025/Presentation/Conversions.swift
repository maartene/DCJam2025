//
//  Conversions.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

import raylib
import Model

public func target(from position: Coordinate, heading: CompassDirection) -> Coordinate {
    position + heading.forward
}

extension Coordinate {
    public var toVector3: Vector3 {
        Vector3(x: Float(x), y: 0, z: Float(y))
    }
}

extension Color {
    public static func * (color: Color, scalar: Float) -> Color {
        let r = Float(color.r) * scalar
        let g = Float(color.g) * scalar
        let b = Float(color.b) * scalar

        return Color(r: UInt8(r), g: UInt8(g), b: UInt8(b), a: color.a)
    }
}

public func getSpriteAndPositionForTileAtPosition(
    _ position: Coordinate, on floor: Floor, offsetX: Int32 = 0, offsetY: Int32 = 0
) -> (spriteName: String, displayX: Int32, displayY: Int32) {
    let spriteSize: Int32 = 16

    let tileToSpriteMap: [Tile: String] = [
        .wall: "wall",
        .stairsDown: "stairsDown",
        .stairsUp: "stairsUp"
    ]

    let tile = floor.tileAt(position)
    let correctedX = Int32(floor.maxX - position.x) * spriteSize + offsetX
    let correctedY = Int32(floor.maxY - position.y) * spriteSize + offsetY

    let spriteName = tileToSpriteMap[tile, default: "\(tile)"]

    return (spriteName, correctedX, correctedY)
}

public func getSpriteAndPositionForPartyAtPosition(
    _ position: Coordinate, heading: CompassDirection, on floor: Floor, offsetX: Int32 = 0,
    offsetY: Int32 = 0
) -> (spriteName: String, displayX: Int32, displayY: Int32) {
    let spriteSize: Int32 = 16

    let headingToSpriteMap: [CompassDirection: String] = [
        .north: "north",
        .east: "west",
        .south: "south",
        .west: "east"
    ]

    let correctedX = Int32(floor.maxX - position.x) * spriteSize + offsetX
    let correctedY = Int32(floor.maxY - position.y) * spriteSize + offsetY

    let spriteName = headingToSpriteMap[heading]!

    return (spriteName, correctedX, correctedY)
}

public func hpBarColor(currentHP: Int, maxHP: Int) -> Color {
    return switch Float(currentHP) / Float(maxHP) {
    case 0 ..< 0.25: Color.red
    case 0.25 ..< 0.45: Color.yellow
    default: Color.green
    }
}

public struct Drawable3D: Equatable {
    let modelName: String
    let position: Vector3
    let up: Vector3
    let rotation: Float
    let tint: Color
    let scale: Vector3
    
    static func makeWall(position: Coordinate) -> Drawable3D {
        Drawable3D(modelName: "wall", position: position.toVector3, up: .up, rotation: 0, tint: .white, scale: .one.scale(0.25))
    }
    
    static func makeFloor(position: Coordinate) -> Drawable3D {
        Drawable3D(modelName: "floor_wood_large", position: position.toVector3 + Vector3(x: 0, y: -0.5, z: 0), up: .up, rotation: 0, tint: .white, scale: .one.scale(0.25))
    }
    
    static func makeCeiling(position: Coordinate) -> Drawable3D {
        Drawable3D(modelName: "ceiling_tile", position: position.toVector3 + Vector3(x: 0, y: 0.5, z: 0), up: .up, rotation: 0, tint: .white, scale: .one.scale(0.25))
    }
    
    static func makeStairsUp(position: Coordinate) -> Drawable3D {
        Drawable3D(modelName: "stairs", position: position.toVector3 + Vector3(x: 0, y: -0.5, z: 0.5), up: .up, rotation: 180, tint: .white, scale: .one.scale(0.25))
    }
    
    static func makeStairsDown(position: Coordinate) -> Drawable3D {
        Drawable3D(modelName: "stairs", position: position.toVector3 + Vector3(x: 0, y: -1.5, z: 0.5), up: .up, rotation: 180, tint: .white, scale: .one.scale(0.25))
    }
    
    static func makeTarget(position: Coordinate) -> Drawable3D {
        Drawable3D(modelName: "chest_gold", position: position.toVector3 + Vector3(x: 0, y: -0.5, z: 0), up: .up, rotation: 180, tint: .white, scale: .one.scale(0.25))
    }
}

public func floorToDrawables(_ floor: Floor) -> [Drawable3D] {
    var result = [Drawable3D]()
    for y in 0 ... floor.maxY {
        for x in 0 ... floor.maxX {
            let coordinate = Coordinate(x: x, y: y)
            switch floor.tileAt(coordinate) {
            case .floor:
                result.append(.makeFloor(position: coordinate))
                result.append(.makeCeiling(position: coordinate))
            case .wall:
                result.append(.makeWall(position: coordinate))
            case .stairsUp:
                result.append(.makeStairsUp(position: coordinate))
            case .stairsDown:
                result.append(.makeStairsDown(position: coordinate))
                result.append(.makeCeiling(position: coordinate))
            case .target:
                result.append(.makeTarget(position: coordinate))
                result.append(.makeFloor(position: coordinate))
                result.append(.makeCeiling(position: coordinate))
            }
        }
    }
    return result
}

extension Vector3: @retroactive Equatable {
    public static func == (lhs: Vector3, rhs: Vector3) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}
