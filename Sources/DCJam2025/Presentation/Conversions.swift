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
) -> Drawable2D {
    let spriteSize: Int32 = 16

    let tileToSpriteMap: [Tile: String] = [
        .wall: "wall",
        .stairsDown: "stairsDown",
        .stairsUp: "stairsUp"
    ]

    let tile = floor.tileAt(position)
    let correctedX = Float(Int32(floor.maxX - position.x) * spriteSize + offsetX)
    let correctedY = Float(Int32(floor.maxY - position.y) * spriteSize + offsetY)

    let spriteName = tileToSpriteMap[tile, default: "\(tile)"]

    return Drawable2D(spriteName: spriteName, position: Vector2(x: correctedX, y: correctedY), tint: .white)
}

public func getSpriteAndPositionForEntityAtPosition(
    _ position: Coordinate, heading: CompassDirection, on floor: Floor, offsetX: Int32 = 0,
    offsetY: Int32 = 0
) -> (spriteName: String, position: Vector2) {
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

    return (spriteName, Vector2(x: Float(correctedX), y: Float(correctedY)))
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
    
    static func makeEntity(_ entity: Enemy) -> [Drawable3D] {
        [
            Drawable3D(modelName: "Skeleton_Warrior", position: entity.position.toVector3 + Vector3(x: 0, y: -0.5, z: 0), up: .up, rotation: entity.heading.rotation, tint: .white, scale: .one.scale(0.5)),
            Drawable3D(modelName: "shadow", position: entity.position.toVector3 + Vector3(x: 0, y: -0.487, z: 0), up: .up, rotation: 0, tint: .shadow, scale: .one.scale(0.5))
        ]
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

public struct Drawable2D: Equatable {
    let spriteName: String
    let position: Vector2
    let tint: Color
    
    static func makeParty(_ world: World, offsetX: Int32 = 0, offsetY: Int32 = 0) -> Drawable2D {
        let spriteNameAndPosition = getSpriteAndPositionForEntityAtPosition(world.partyPosition, heading: world.partyHeading, on: world.currentFloor, offsetX: offsetX, offsetY: offsetY)

        return Drawable2D(
            spriteName: spriteNameAndPosition.spriteName,
            position: spriteNameAndPosition.position,
            tint: .white
        )
    }
    
    static func makeEnemy(enemy: Enemy, on floor: Floor, offsetX: Int32 = 0, offsetY: Int32 = 0) -> Drawable2D {
        let spriteNameAndPosition = getSpriteAndPositionForEntityAtPosition(enemy.position, heading: enemy.heading, on: floor, offsetX: offsetX, offsetY: offsetY)

        return Drawable2D(spriteName: spriteNameAndPosition.spriteName, position: spriteNameAndPosition.position, tint: .red)
    }
}

public func minimap(for world: World, minimapOffset: Int32 = 0) -> [Drawable2D] {
    var result = world.visitedTilesOnCurrentFloor
        .map { getSpriteAndPositionForTileAtPosition(
            $0, on: world.currentFloor, offsetX: minimapOffset,
            offsetY: minimapOffset)
        }

    result.append(Drawable2D.makeParty(world, offsetX: minimapOffset, offsetY: minimapOffset))

    let enemyDrawables = world.aliveEnemiesOnCurrentFloor
        .filter { world.currentFloor.hasUnobstructedView(from: world.partyPosition, to: $0.position) }
        .map { Drawable2D.makeEnemy(enemy: $0, on: world.currentFloor, offsetX: minimapOffset, offsetY: minimapOffset) }
    
    result.append(contentsOf: enemyDrawables)
    
    return result
}

extension CompassDirection {
    var rotation: Float {
        switch self {
        case .north:
            return 0
        case .east:
            return 90
        case .south:
            return 180
        case .west:
            return 270
        }
    }
}
