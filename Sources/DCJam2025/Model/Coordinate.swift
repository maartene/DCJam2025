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
}

extension Coordinate: Equatable { }
extension Coordinate: Hashable { }
