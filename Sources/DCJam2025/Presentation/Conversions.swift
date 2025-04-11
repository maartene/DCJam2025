//
//  Conversions.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

func light(position: Coordinate, vantagePoint: Coordinate) -> Float {
    let distance = position.distanceTo(vantagePoint)
    return 1.0 / Float(distance)
}
