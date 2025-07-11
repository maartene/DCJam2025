//
//  Conversions.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

import raylib

func light(position: Coordinate, vantagePoint: Coordinate) -> Float {
    let distance = position.distanceTo(vantagePoint)
    return min(Float(1.0) / Float(distance), Float(1.0))
}

func target(from position: Coordinate, heading: CompassDirection) -> Coordinate {
    position + heading.forward
}

extension Coordinate {
    public var toVector3: Vector3 {
        Vector3(x: Float(x), y: 0, z: Float(y))
    }
}

extension Color {
    static func * (color: Color, scalar: Float) -> Color {
        let r = Float(color.r) * scalar
        let g = Float(color.g) * scalar
        let b = Float(color.b) * scalar

        return Color(r: UInt8(r), g: UInt8(g), b: UInt8(b), a: color.a)
    }
}

func getSpriteAndPositionForTileAtPosition(
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

func getSpriteAndPositionForPartyAtPosition(
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
