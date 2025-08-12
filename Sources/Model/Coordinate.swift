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

extension Coordinate {
    private static func plotLineLow(x0: Int, y0: Int, x1: Int, y1: Int) -> [Coordinate] {
        var result = [Coordinate]()

        let dx = Double(x1) - Double(x0)
        var dy = Double(y1) - Double(y0)
        var yi = 1.0

        if dy < 0 {
            yi = -1
            dy = -dy
        }

        var D: Double = 2*dy - dx
        var y = Double(y0)

        for x in x0 ... x1 {
            result.append(Coordinate(x: x, y: Int(y)))
            if D > 0 {
               y = y + yi
               D = D - 2*dx
            }
            D = D + 2*dy
        }

        return result
    }

    private static func plotLineHigh(x0: Int, y0: Int, x1: Int, y1: Int) -> [Coordinate] {
        var result = [Coordinate]()

        var dx = Double(x1) - Double(x0)
        let dy = Double(y1) - Double(y0)

        var xi = 1.0

        if dx < 0 {
            xi = -1
            dx = -dx
        }

        var D: Double = 2*dx - dy
        var x = Double(x0)

        for y in y0 ... y1 {
            result.append(Coordinate(x: Int(x), y: y))
            if D > 0 {
               x = x + xi
               D = D - 2*dy
            }
            D = D + 2*dx
        }
        return result
    }

    static func plotLine(from c0: Coordinate, to c1: Coordinate) -> [Coordinate] {
        let x0 = c0.x
        let y0 = c0.y
        let x1 = c1.x
        let y1 = c1.y

        if abs(y1 - y0) < abs(x1 - x0) {
            if x0 > x1 {
                return plotLineLow(x0: x1, y0: y1, x1: x0, y1: y0).reversed()
            } else {
                return plotLineLow(x0: x0, y0: y0, x1: x1, y1: y1)
            }
        } else {
            if y0 > y1 {
                return plotLineHigh(x0: x1, y0: y1, x1: x0, y1: y0).reversed()
            } else {
                return plotLineHigh(x0: x0, y0: y0, x1: x1, y1: y1)
            }
        }
    }
}
