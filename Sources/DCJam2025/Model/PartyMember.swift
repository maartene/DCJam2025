//
//  PartyMember.swift
//  DCJam2025
//
//  Created by Maarten Engels on 24/04/2025.
//

final class PartyMember {
    private(set) var currentHP = 10

    var isAlive: Bool {
        currentHP > 0
    }

    func takeDamage(_ amount: Int) {
        currentHP -= amount
    }
    
    func attack(potentialTargets: Set<Enemy>, partyPosition: Coordinate) {
        potentialTargets.forEach {
            if partyPosition.manhattanDistanceTo($0.position) <= 1 {
                $0.damage(amount: 2)
            }
        }
    }
}
