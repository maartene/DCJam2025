//
//  Coordinate.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

import Foundation

struct Coordinate {
    var x: Int
    var y: Int
        
    static func +(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        Coordinate(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func +=(lhs: inout Coordinate, rhs: Coordinate) {
        lhs = lhs + rhs
    }
    
    func distanceTo(_ coordinate: Coordinate) -> Double {
        let vector = coordinate - self
        return vector.magnitude
    }
    
    var magnitude: Double {
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
}

extension Coordinate: Equatable { }
extension Coordinate: Hashable { }
