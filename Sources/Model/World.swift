//
//  World.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

import Foundation

public final class World {
    public enum WorldState {
        case inProgress
        case won
        case defeated
    }

    public private(set) var partyPosition: Coordinate
    public private(set) var partyHeading: CompassDirection
    private var currentFloorIndex = 0
    private var floors: [Floor]
    private var visitedTilesOnFloor = [Int: Set<Coordinate>]()
    private var enemies: [Int: Set<Enemy>]

    public let partyMembers = PartyMembers(members: [
        PartyMember.makeMeleePartyMember(name: "Loretta"),
        PartyMember.makeMeleePartyMember(name: "Leroy"),
        PartyMember.makeRanger(name: "Lenny"),
        PartyMember.makeMage(name: "Ludo")
    ])

    // Initializers
    public init(floors: [Floor], partyStartPosition: Coordinate = Coordinate(x: 0, y: 0), partyStartHeading: CompassDirection = CompassDirection.north, enemies: [Set<Enemy>] = [[]]) {
        self.floors = floors
        self.partyPosition = partyStartPosition
        self.partyHeading = partyStartHeading
        self.enemies = [:]

        var floorIndex = 0
        for enemiesOnFloor in enemies {
            self.enemies[floorIndex] = Set(enemiesOnFloor)
            floorIndex += 1
        }

        updateVisitedTiles()
    }

    // Queries
    public var currentFloor: Floor {
        floors[currentFloorIndex]
    }

    public var enemiesOnCurrentFloor: Set<Enemy> {
        enemies[currentFloorIndex, default: []]
    }

    public var aliveEnemiesOnCurrentFloor: Set<Enemy> {
        enemies[currentFloorIndex, default: []]
            .filter { $0.isAlive }
    }

    public var state: WorldState {
        if partyMembers.hasAlivePartyMember == false {
            return .defeated
        }

        if currentFloor.tileAt(partyPosition) == .target {
            return .won
        }

        return .inProgress
    }

    public var visitedTilesOnCurrentFloor: Set<Coordinate> {
        visitedTilesOnFloor[currentFloorIndex, default: []]
    }

    func pathToParty(from position: Coordinate) -> [Coordinate] {
        let bfs = currentFloor.BFS(from: position, to: partyPosition)
        return currentFloor.getPath(from: position, to: partyPosition, using: bfs)
    }

    // MARK: Commands
    public func executeCommand(_ command: PartyCommand, at time: Date) {
        guard state == .inProgress else {
            return
        }

        switch command {
        case .move(direction: let direction):
            performMovement(direction: direction)
        case .turnClockwise:
            partyHeading = partyHeading.rotatedClockwise()
        case .turnCounterClockwise:
            partyHeading = partyHeading.rotatedCounterClockwise()
        case .executeAbility(let user, let ability):
            partyMembers.executeAbility(ability, from: user, in: self, at: time)
        }
    }

    private func performMovement(direction: MovementDirection) {
        let newPosition = partyPosition + direction.toCompassDirection(facing: partyHeading).toCoordinate

        let occupiedPositionsByEnemies = aliveEnemiesOnCurrentFloor.map { $0.position }
        guard occupiedPositionsByEnemies.contains(newPosition) == false else {
            return
        }

        switch currentFloor.tileAt(newPosition) {
        case .floor:
            partyPosition = newPosition
        case .wall:
            break
        case .stairsUp:
            currentFloorIndex += 1
            partyPosition = newPosition
        case .stairsDown:
            currentFloorIndex -= 1
            partyPosition = newPosition
        default:
            partyPosition = newPosition
        }

        updateVisitedTiles()
    }

    private func updateVisitedTiles() {
        visitedTilesOnFloor[currentFloorIndex] = visitedTilesOnCurrentFloor.union(partyPosition.squareAround)
    }

    // MARK: update
    public func update(at time: Date) {
        for enemy in aliveEnemiesOnCurrentFloor {
            enemy.act(in: self, at: time)
        }
    }
}

public enum PartyCommand {
    case move(direction: MovementDirection)
    case turnClockwise
    case turnCounterClockwise
    case executeAbility(user: SinglePartyPosition, ability: any Ability)
}

extension World: Equatable {
    public static func == (lhs: World, rhs: World) -> Bool {
        lhs.partyPosition == rhs.partyPosition &&
        lhs.partyHeading == rhs.partyHeading &&
        lhs.floors == rhs.floors &&
        lhs.currentFloorIndex == rhs.currentFloorIndex &&
        lhs.enemies == rhs.enemies
    }
}
