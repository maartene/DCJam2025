//
//  PartyMember.swift
//  DCJam2025
//
//  Created by Maarten Engels on 24/04/2025.
//

import Foundation

public final class PartyMember {
    public let name: String
    public private(set) var currentHP = 10
    private var cooldownExpires = Date()
    private var cooldown = 1.0

    init (name: String) {
        self.name = name
    }

    public var isAlive: Bool {
        currentHP > 0
    }

    public func takeDamage(_ amount: Int) {
        currentHP -= amount
    }

    public func cooldownHasExpired(at time: Date) -> Bool {
        time >= cooldownExpires
    }

    func attack(potentialTargets: Set<Enemy>, partyPosition: Coordinate, at time: Date) {
        guard cooldownHasExpired(at: time) else {
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
