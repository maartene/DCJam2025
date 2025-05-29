//
//  Enemy.swift
//  DCJam2025
//
//  Created by Maarten Engels on 29/05/2025.
//

import Foundation

class Enemy {
    let cooldown = 0.75
    var position: Coordinate
    var cooldownExpires = Date()
    
    init(position: Coordinate) {
        self.position = position
    }
}

extension Enemy: Hashable {
    static func == (lhs: Enemy, rhs: Enemy) -> Bool {
        lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
