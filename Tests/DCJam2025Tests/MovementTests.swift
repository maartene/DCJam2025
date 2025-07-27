import Testing
import Foundation
import Model

@Suite("Party movement should") struct PartyMovementTests {
    let worldWithSingleFloor = World(floors: [Floor()])

    @Test("get to the expected coordinate, when it moves in a specified direction", arguments: [
        (MovementDirection.forward, Coordinate(x: 0, y: 1)),
        (MovementDirection.backwards, Coordinate(x: 0, y: -1)),
        (MovementDirection.left, Coordinate(x: -1, y: 0)),
        (MovementDirection.right, Coordinate(x: 1, y: 0))
    ]) func movePartyForward(testcase: (direction: MovementDirection, expectedPosition: Coordinate)) {
        worldWithSingleFloor.executeCommand(.move(direction: testcase.direction), at: Date())

        #expect(worldWithSingleFloor.partyPosition == testcase.expectedPosition)
    }

    @Test("get to coordinate (0,2) when it moves forward twice") func movePartyForwardTwice() {
        worldWithSingleFloor.executeCommand(.move(direction: .forward), at: Date())
        worldWithSingleFloor.executeCommand(.move(direction: .forward), at: Date())

        #expect(worldWithSingleFloor.partyPosition == Coordinate(x: 0, y: 2))
    }

    @Test("stays in the same position, when you move forward first, then right, then back and finally left") func moveInACircle() {
        worldWithSingleFloor.executeCommand(.move(direction: .forward), at: Date())
        worldWithSingleFloor.executeCommand(.move(direction: .right), at: Date())
        worldWithSingleFloor.executeCommand(.move(direction: .backwards), at: Date())
        worldWithSingleFloor.executeCommand(.move(direction: .left), at: Date())

        #expect(worldWithSingleFloor.partyPosition == Coordinate(x: 0, y: 0))
    }

    @Test("get to the expected coordinate when it moves in the designated direction while heading a certain way", arguments: [
        (Coordinate(x: 0, y: 0), CompassDirection.west, MovementDirection.forward, Coordinate(x: -1, y: 0)),
        (Coordinate(x: -4, y: 5), CompassDirection.south, MovementDirection.backwards, Coordinate(x: -4, y: 6)),
        (Coordinate(x: 11, y: -4), CompassDirection.east, MovementDirection.right, Coordinate(x: 11, y: -5)),
        (Coordinate(x: 24, y: 72), CompassDirection.north, MovementDirection.left, Coordinate(x: 23, y: 72)),
        (Coordinate(x: 24, y: 72), CompassDirection.south, MovementDirection.left, Coordinate(x: 25, y: 72))
    ]) func movementTakesHeadingIntoAccount(testcase: (startPosition: Coordinate, heading: CompassDirection, movementDirection: MovementDirection, expectedPosition: Coordinate)) {
        let world = World(floors: [Floor()], partyStartPosition: testcase.startPosition, partyStartHeading: testcase.heading)

        world.executeCommand(.move(direction: testcase.movementDirection), at: Date())

        #expect(world.partyPosition == testcase.expectedPosition)
    }

    @Test("not move through walls") func cannotMoveThroughWalls() {
        let map = Floor([
            ["#", "#", "#", "#"],
            ["#", ".", ".", "#"],
            ["#", "#", "#", "#"]
        ])
        let world = World(floors: [map], partyStartPosition: Coordinate(x: 0, y: 1))

        world.executeCommand(.move(direction: .forward), at: Date())

        #expect(world.partyPosition == Coordinate(x: 0, y: 1))
    }
    
    @Test("not move through enemies") func cannotMoveThroughEnemies() {
        let world = makeWorld(from: [
            ".s"
        ])
        
        world.executeCommand(.move(direction: .right), at: Date())
        
        #expect(world.partyPosition == Coordinate(x: 0, y: 0))
    }
}

@Suite("Party rotation should") struct PartyRotationTests {
    let worldWithSingleFloor = World(floors: [Floor()])

    @Test("face north when the new world is created") func partyInNewWorldFacesNorth() {
        #expect(worldWithSingleFloor.partyHeading == .north)
    }

    @Test("face east when it turns clockwise") func turnClockwiseOnce() {
        worldWithSingleFloor.executeCommand(.turnClockwise, at: Date())

        #expect(worldWithSingleFloor.partyHeading == .east)
    }

    @Test("face west when it turns clockwise three times") func turnClockwiseThreeTimes() {
        worldWithSingleFloor.executeCommand(.turnClockwise, at: Date())
        worldWithSingleFloor.executeCommand(.turnClockwise, at: Date())
        worldWithSingleFloor.executeCommand(.turnClockwise, at: Date())

        #expect(worldWithSingleFloor.partyHeading == .west)
    }

    @Test("face west when it turns counter clockwise once") func turnCounterClockwise() {
        worldWithSingleFloor.executeCommand(.turnCounterClockwise, at: Date())

        #expect(worldWithSingleFloor.partyHeading == .west)
    }
}

@Suite("When moving from one floor to another") struct MultipleLevelTests {
    @Test("a new party starts at the first floor") func newPartyStartsAtFloor0() {
        let floors = [
            Floor(),
            Floor([["#"]])
        ]

        let world = World(floors: floors)

        #expect(world.currentFloor == floors[0])
    }

    @Test("when a party moves into a staircase, it should move to the next floor") func partyMovesUpStairs() {
        let floors = [
            Floor([[".", "<"]]),
            Floor([[".", ">"]])
            ]

        let world = World(floors: floors)

        world.executeCommand(.move(direction: .right), at: Date())

        #expect(world.currentFloor == floors[1])
    }

    @Test("when a party moves into a staircase leading up, and then into a staircase leading down, it should be back at the first floor") func partyMovesUpAndDownStairs() {
        let floors = [
            Floor([[".", "<"]]),
            Floor([[".", ">"]])
            ]

        let world = World(floors: floors)

        world.executeCommand(.move(direction: .right), at: Date())
        world.executeCommand(.move(direction: .left), at: Date())
        world.executeCommand(.move(direction: .right), at: Date())

        #expect(world.currentFloor == floors[0])
    }
}
