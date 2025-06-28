//
//  PartyMember.swift
//  DCJam2025
//
//  Created by Maarten Engels on 24/04/2025.
//

import Foundation

final class PartyMember {
    private(set) var currentHP = 10
    private var cooldownExpires = Date()
    private var cooldown = 1.0


    var isAlive: Bool {
        currentHP > 0
    }

    func takeDamage(_ amount: Int) {
        currentHP -= amount
    }
    
    func attack(potentialTargets: Set<Enemy>, partyPosition: Coordinate, at time: Date) {
        guard time >= cooldownExpires else {
            return
        }
        
        potentialTargets.forEach {
            if partyPosition.manhattanDistanceTo($0.position) <= 1 {
                $0.damage(amount: 2)
            }
        }
        cooldownExpires = time.addingTimeInterval(cooldown)
    }
}
