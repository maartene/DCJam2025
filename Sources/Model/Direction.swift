//
//  Direction.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

public enum MovementDirection: Sendable {
    case forward
    case backwards
    case left
    case right

    private var toCompassDirectionWhenFacingNorth: CompassDirection {
        switch self {
        case .forward: .north
        case .right: .east
        case .backwards: .south
        case .left: .west
        }
    }

    func toCompassDirection(facing: CompassDirection = .north) -> CompassDirection {
        let numberOfQuarterTurns = facing.numberOfQuarterTurnsToNorth
        return toCompassDirectionWhenFacingNorth.rotatedClockwise(numberOfQuarterTurns)
    }
}

public enum CompassDirection: Sendable {
    case north
    case east
    case south
    case west

    var numberOfQuarterTurnsToNorth: Int {
        switch self {
        case .north: 0
        case .east:  1
        case .south: 2
        case .west:  3
        }
    }

    func rotatedClockwise(_ times: Int = 1) -> CompassDirection {
        let rotatedClockwiseDirections: [CompassDirection: CompassDirection] = [
            .north: .east,
            .east: .south,
            .south: .west,
            .west: .north
        ]

        var rotatedDirection = self

        for _ in 0 ..< times {
            rotatedDirection = rotatedClockwiseDirections[rotatedDirection]!
        }

        return rotatedDirection
    }

    func rotatedCounterClockwise(_ times: Int = 1) -> CompassDirection {
        let rotatedCounterClockwiseDirections: [CompassDirection: CompassDirection] = [
            .north: .west,
            .east: .north,
            .south: .east,
            .west: .south
        ]

        var rotatedDirection = self

        for _ in 0 ..< times {
            rotatedDirection = rotatedCounterClockwiseDirections[rotatedDirection]!
        }

        return rotatedDirection
    }

    var toCoordinate: Coordinate {
        switch self {
        case .north: return Coordinate(x: 0, y: 1)
        case .south:  return Coordinate(x: 0, y: -1)
        case .west:  return Coordinate(x: -1, y: 0)
        case .east:  return Coordinate(x: 1, y: 0)
        }
    }

    static var randomValue: CompassDirection {
        switch Int.random(in: 0 ..< 4) {
        case 0: return .north
        case 1: return .south
        case 2: return .west
        default: return .east
        }
    }

    public var forward: Coordinate {
        MovementDirection.forward.toCompassDirection(facing: self).toCoordinate
    }
}
