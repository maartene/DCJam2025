//
//  Coordinate.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

import Foundation

public struct Coordinate: Sendable {
    public let x: Int
    public let y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public static func +(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func +=(lhs: inout Coordinate, rhs: Coordinate) {
        lhs = lhs + rhs
    }

    public static func -(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        Coordinate(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public static func *(vector: Coordinate, scalar: Int) -> Coordinate {
        Coordinate(x: vector.x * scalar, y: vector.y * scalar)
    }

    public func distanceTo(_ coordinate: Coordinate) -> Double {
        let vector = coordinate - self
        return vector.magnitude
    }

    public var magnitude: Double {
        sqrt(Double(x*x + y*y))
    }

    static var square3x3: Set<Coordinate> {
        [
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
    }

    var squareAround: Set<Coordinate> {
        Set(Coordinate.square3x3.map {
            $0 + self
        })
    }

    var neighbours: [Coordinate] {
        [
            Coordinate(x: 1, y: 0),
            Coordinate(x: -1, y: 0),
            Coordinate(x: 0, y: +1),
            Coordinate(x: 0, y: -1)
        ].map { $0 + self }
    }

    func manhattanDistanceTo(_ other: Coordinate) -> Int {
        abs(x - other.x) + abs(y - other.y)
    }
}

extension Coordinate: Equatable { }
extension Coordinate: Hashable { }
