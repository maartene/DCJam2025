//
//  RaylibHelpers.swift
//  DCJam2025
//
//  Created by Maarten Engels on 26/05/2025.
//

import raylib

extension Color {
    public static var white: Color {
        Color(r: 255, g: 255, b: 255, a: 255)
    }

    public static var darkGray: Color {
        Color(r: 50, g: 50, b: 50, a: 255)
    }

    public static var black: Color {
        Color(r: 50, g: 50, b: 50, a: 255)
    }

    public static var blue: Color {
        Color(r: 0, g: 0, b: 255, a: 255)
    }

    public static var red: Color {
        Color(r: 255, g: 0, b: 0, a: 255)
    }
}

enum CameraProjection {
    static var PERSPECTIVE: Int32 { 0 }
}

extension Vector3 {
    static var one: Vector3 {
        Vector3(x: 1, y: 1, z: 1)
    }

    static var up: Vector3 {
        Vector3(x: 0, y: 1, z: 0)
    }

    static func +(lhs: Vector3, rhs: Vector3) -> Vector3 {
        Vector3(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    func scale(_ scalar: Float) -> Vector3 {
        Vector3(x: x * scalar, y: y * scalar, z: z * scalar)
    }
}

func isKeyPressed(_ key: KeyboardKey) -> Bool {
    IsKeyPressed(Int32(key.rawValue))
}

enum GuiState {
    static let normal: Int32 = 0
    static let hovered: Int32 = 1
    static let pressed: Int32 = 2
    static let disabled: Int32 = 3
}
