//
//  Conversions.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

import Raylib

func light(position: Coordinate, vantagePoint: Coordinate) -> Float {
    let distance = position.distanceTo(vantagePoint)
    return 1.0 / Float(distance)
}

extension Coordinate {
    var toVector3: Vector3 {
        Vector3(x: Float(x), y: 0, z: Float(y))
    }
}

extension Color {
    static func *(color: Color, scalar: Float) -> Color {
        let r = Float(color.r) * scalar
        let g = Float(color.g) * scalar
        let b = Float(color.b) * scalar
        
        return Color(r: UInt8(r), g: UInt8(g), b: UInt8(b), a: color.a)
    }
}
