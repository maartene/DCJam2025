//
//  Enemy.swift
//  DCJam2025
//
//  Created by Maarten Engels on 29/05/2025.
//

class Enemy {
    var position: Coordinate
    
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
