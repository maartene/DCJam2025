//
//  LostConditionTests.swift
//  DCJam2025
//
//  Created by Maarten Engels on 24/04/2025.
//

import Testing
@testable import DCJam2025

@Suite("The lose condition for this world should") struct LostConditionTests {
    let worldWithSingleFloor = World(floors: [Floor()])
    
    @Test("be 'defeated' when all party members are rendered unconcious") func loseWhenAllPartyMembersAreUnconscious() {
        let world = makeWorldWithUnconciousPlayers()

        #expect(world.state == .defeated)
    }

    @Test("be 'inProgress' when at least one party member is not unconcious") func notLostWhenAtLeastOnePartyMemberIsAlive() {
        worldWithSingleFloor.damage(position: \.frontLeft, amount: Int.max)
        worldWithSingleFloor.damage(position: \.frontRight, amount: Int.max)
        worldWithSingleFloor.damage(position: \.backLeft, amount: Int.max)

        #expect(worldWithSingleFloor.state != .defeated)
    }

    @Test("not allow movement when in the lose condition state") func losingGameMakesMovementImpossible() {
        let world = makeWorldWithUnconciousPlayers()

        world.executeCommand(.move(direction: .forward))

        #expect(world.partyPosition == Coordinate(x: 0, y: 0))
    }

    @Test("not allow rotation when the party reaches the target") func losingGameMakesRotationImpossible() {
        let world = makeWorldWithUnconciousPlayers()

        world.executeCommand(.turnCounterClockwise)

        #expect(world.partyHeading == .north)
    }

    private func makeWorldWithUnconciousPlayers() -> World {
        let world = worldWithSingleFloor

        world.damage(position: \.frontLeft, amount: Int.max)
        world.damage(position: \.frontRight, amount: Int.max)
        world.damage(position: \.backLeft, amount: Int.max)
        world.damage(position: \.backRight, amount: Int.max)

        return world
    }
}
