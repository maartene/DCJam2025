//
//  RaylibHelpers.swift
//  DCJam2025
//
//  Created by Maarten Engels on 26/05/2025.
//

import raylib

extension Color {
//    #define LIGHTGRAY  CLITERAL(Color){ 200, 200, 200, 255 }   // Light Gray
//    #define GRAY       CLITERAL(Color){ 130, 130, 130, 255 }   // Gray
//    #define GOLD       CLITERAL(Color){ 255, 203, 0, 255 }     // Gold
//    #define ORANGE     CLITERAL(Color){ 255, 161, 0, 255 }     // Orange
//    #define PINK       CLITERAL(Color){ 255, 109, 194, 255 }   // Pink
//    #define MAROON     CLITERAL(Color){ 190, 33, 55, 255 }     // Maroon
//    #define LIME       CLITERAL(Color){ 0, 158, 47, 255 }      // Lime
//    #define DARKGREEN  CLITERAL(Color){ 0, 117, 44, 255 }      // Dark Green
//    #define SKYBLUE    CLITERAL(Color){ 102, 191, 255, 255 }   // Sky Blue
//    #define DARKBLUE   CLITERAL(Color){ 0, 82, 172, 255 }      // Dark Blue
//    #define PURPLE     CLITERAL(Color){ 200, 122, 255, 255 }   // Purple
//    #define VIOLET     CLITERAL(Color){ 135, 60, 190, 255 }    // Violet
//    #define DARKPURPLE CLITERAL(Color){ 112, 31, 126, 255 }    // Dark Purple
//    #define BEIGE      CLITERAL(Color){ 211, 176, 131, 255 }   // Beige
//    #define BROWN      CLITERAL(Color){ 127, 106, 79, 255 }    // Brown
//    #define DARKBROWN  CLITERAL(Color){ 76, 63, 47, 255 }      // Dark Brown
//
//    #define BLANK      CLITERAL(Color){ 0, 0, 0, 0 }           // Blank (Transparent)
//    #define MAGENTA    CLITERAL(Color){ 255, 0, 255, 255 }     // Magenta
//    #define RAYWHITE   CLITERAL(Color){ 245, 245, 245, 255 }   // My own White (raylib logo)
    
    public static var white: Color {
        Color(r: 255, g: 255, b: 255, a: 255)
    }

    public static var darkGray: Color {
        Color(r: 80, g: 80, b: 80, a: 255)
    }

    public static var black: Color {
        Color(r: 0, g: 0, b: 0, a: 255)
    }

    public static var blue: Color {
        Color(r: 0, g: 121, b: 241, a: 255)
    }

    public static var red: Color {
        Color(r: 230, g: 41, b: 55, a: 255)
    }
    
    public static var green: Color {
        Color(r: 0, g: 228, b: 48, a: 255)
    }
    
    public static var yellow: Color {
        Color(r: 253, g: 249, b: 0, a: 255)
    }
}

extension Color: @retroactive Equatable {
    public static func == (lhs: Color, rhs: Color) -> Bool {
        lhs.a == rhs.a &&
        lhs.r == rhs.r &&
        lhs.g == rhs.g &&
        lhs.b == rhs.b
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

extension Vector2 {
    static func +(lhs: Vector2, rhs: Vector2) -> Vector2 {
        Vector2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

let shaderUniformVec4: Int32 = 3
