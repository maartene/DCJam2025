//
//  Enemy.swift
//  DCJam2025
//
//  Created by Maarten Engels on 29/05/2025.
//

import Foundation

class Enemy {
    init(position: Coordinate) {
        self.position = position
    }

    let cooldown = 0.75
    var position: Coordinate
    var cooldownExpires = Date()

    func act(in world: World, at time: Date) {
        // This method should be overridden by subclasses
    }

    internal func enemyCooldownHasExpired(at time: Date) -> Bool {
        cooldownExpires <= time
    }

    internal func enemyIsNearParty(in world: World) -> Bool {
        world.partyPosition.squareAround.contains(position)
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

final class MeleeEnemy: Enemy {
    override func act(in world: World, at time: Date) {
        if enemyIsNearParty(in: world) && enemyCooldownHasExpired(at: time) {
            attackParty(in: world, at: time)
        }
    }

    private func attackParty(in world: World, at time: Date) {
        let aliveFrontRowPartyMembers = world.partyMembers.frontRow
            .filter { $0.isAlive }
        
        aliveFrontRowPartyMembers.randomElement()?.takeDamage(1)
        cooldownExpires = time.addingTimeInterval(cooldown)
    }
}

final class RangedEnemy: Enemy {
    override func act(in world: World, at time: Date) {
        if enemyIsNearParty(in: world) && enemyCooldownHasExpired(at: time) {
            attackParty(in: world, at: time)
        }
    }

    private func attackParty(in world: World, at time: Date) {
        let alivePartyMembers = world.partyMembers.all
            .filter { $0.isAlive }
        
        alivePartyMembers.randomElement()?.takeDamage(1)
        cooldownExpires = time.addingTimeInterval(cooldown)
    }
}