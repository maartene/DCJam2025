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

    func act(in world: World, at time: Date) {
        if enemyIsNearParty(in: world) && enemyCooldownHasExpired(at: time) {
            attackParty(in: world, at: time)
        }
    }

    private func enemyIsNearParty(in world: World) -> Bool {
        world.partyPosition.squareAround.contains(position)
    }

    private func enemyCooldownHasExpired(at time: Date) -> Bool {
        cooldownExpires <= time
    }

    private func attackParty(in world: World, at time: Date) {
        let aliveFrontRowPartyMembers = world.partyMembers.frontRow
            .filter { $0.isAlive }
        
        aliveFrontRowPartyMembers.randomElement()?.takeDamage(1)
        cooldownExpires = time.addingTimeInterval(cooldown)
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
