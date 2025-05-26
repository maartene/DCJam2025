//
//  LostConditionTests.swift
//  DCJam2025
//
//  Created by Maarten Engels on 24/04/2025.
//

import Testing
@testable import DCJam2025

@Suite("The lose condition for this world should") struct LostConditionTests {
    @Test("be 'defeated' when all party members are rendered unconcious") func loseWhenAllPartyMembersAreUnconscious() {
        let world = makeWorldWithUnconciousPlayers()

        #expect(world.state == .defeated)
    }

    @Test("be 'inProgress' when at least one party member is not unconcious") func notLostWhenAtLeastOnePartyMemberIsAlive() {
        let world = World(map: Floor())

        world.partyMembers[0].takeDamage(Int.max)
        world.partyMembers[1].takeDamage(Int.max)
        world.partyMembers[2].takeDamage(Int.max)

        #expect(world.state != .defeated)
    }

    @Test("not allow movement when in the lose condition state") func losingGameMakesMovementImpossible() {
        let world = makeWorldWithUnconciousPlayers()

        world.moveParty(.forward)

        #expect(world.partyPosition == Coordinate(x: 0, y: 0))
    }

    @Test("not allow rotation when the party reaches the target") func losingGameMakesRotationImpossible() {
        let world = makeWorldWithUnconciousPlayers()

        world.turnPartyCounterClockwise()

        #expect(world.partyHeading == .north)
    }

    private func makeWorldWithUnconciousPlayers() -> World {
        let world = World(map: Floor())

        world.partyMembers[0].takeDamage(Int.max)
        world.partyMembers[1].takeDamage(Int.max)
        world.partyMembers[2].takeDamage(Int.max)
        world.partyMembers[3].takeDamage(Int.max)

        return world
    }
}
