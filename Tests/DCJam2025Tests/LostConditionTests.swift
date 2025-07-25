//
//  LostConditionTests.swift
//  DCJam2025
//
//  Created by Maarten Engels on 24/04/2025.
//

import Testing
import Foundation
import Model

@Suite("The lose condition for this world should") struct LostConditionTests {
    let worldWithSingleFloor = World(floors: [Floor()])

    @Test("be 'defeated' when all party members are rendered unconcious") func loseWhenAllPartyMembersAreUnconscious() {
        let world = makeWorldWithUnconciousPlayers()

        #expect(world.state == .defeated)
    }

    @Test("be 'inProgress' when at least one party member is not unconcious") func notLostWhenAtLeastOnePartyMemberIsAlive() {
        worldWithSingleFloor.partyMembers[.frontLeft].takeDamage(Int.max)
        worldWithSingleFloor.partyMembers[.frontRight].takeDamage(Int.max)
        worldWithSingleFloor.partyMembers[.backLeft].takeDamage(Int.max)

        #expect(worldWithSingleFloor.state != .defeated)
    }

    @Test("not allow movement when in the lose condition state") func losingGameMakesMovementImpossible() {
        let world = makeWorldWithUnconciousPlayers()

        world.executeCommand(.move(direction: .forward), at: Date())

        #expect(world.partyPosition == Coordinate(x: 0, y: 0))
    }

    @Test("not allow rotation when the party reaches the target") func losingGameMakesRotationImpossible() {
        let world = makeWorldWithUnconciousPlayers()

        world.executeCommand(.turnCounterClockwise, at: Date())

        #expect(world.partyHeading == .north)
    }

    private func makeWorldWithUnconciousPlayers() -> World {
        let world = worldWithSingleFloor

        let partyMembers = world.partyMembers.getMembers(grouping: .all)
        partyMembers.forEach { $0.takeDamage(Int.max) }

        return world
    }
}
