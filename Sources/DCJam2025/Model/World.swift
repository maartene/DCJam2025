//
//  World.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

import Foundation

final class World {
    enum WorldState {
        case inProgress
        case won
        case defeated
    }

    private(set) var partyPosition: Coordinate
    private(set) var partyHeading: CompassDirection
    private var currentFloorIndex = 0
    private var floors: [Floor]
    private var visitedTilesOnFloor = [Int: Set<Coordinate>]()
    private var enemies: [Int: Set<Enemy>]

    let partyMembers = PartyMembers(members: [
        PartyMember(),
        PartyMember(),
        PartyMember(),
        PartyMember()
    ])

    // Initializers
    init(floors: [Floor], partyStartPosition: Coordinate = Coordinate(x: 0, y: 0), partyStartHeading: CompassDirection = CompassDirection.north, enemies: [Set<Enemy>] = [[]]) {
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
    var currentFloor: Floor {
        floors[currentFloorIndex]
    }
    
    var enemiesOnCurrentFloor: Set<Enemy> {
        enemies[currentFloorIndex, default: []]
    }

    var state: WorldState {
        if partyMembers.hasAlivePartyMember == false {
            return .defeated
        }

        if currentFloor.tileAt(partyPosition) == .target {
            return .won
        }

        return .inProgress
    }

    var visitedTilesOnCurrentFloor: Set<Coordinate> {
        visitedTilesOnFloor[currentFloorIndex, default: []]
    }

    // MARK: Commands
    func executeCommand(_ command: PartyCommand) {
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
        }
    }
    
    func damage(position: KeyPath<PartyMembers, PartyMember>, amount: Int) {
        partyMembers[keyPath: position].takeDamage(amount)
    }

    private func performMovement(direction: MovementDirection) {
        let newPosition = partyPosition + direction.toCompassDirection(facing: partyHeading).toCoordinate

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
    func update(at time: Date) {
        for enemy in enemiesOnCurrentFloor {
            enemy.act(in: self, at: time)
        }
    }
}

extension World: Equatable {
    static func == (lhs: World, rhs: World) -> Bool {
        lhs.partyPosition == rhs.partyPosition &&
        lhs.partyHeading == rhs.partyHeading &&
        lhs.floors == rhs.floors &&
        lhs.currentFloorIndex == rhs.currentFloorIndex &&
        lhs.enemies == rhs.enemies
    }
}

func makeWorld(from floorplans: [String]) -> World {
    let convertedFloorplans = floorplans.map { convertFloorPlanToFloorAndStartposition($0) }
    let enemies = floorplans.map { convertFloorPlanToEnemies($0) }
    let floors = convertedFloorplans.map { $0.floor }
    let startPosition = convertedFloorplans
        .compactMap { $0.startPosition }
        .first ?? Coordinate(x: 0, y: 0)

    return World(floors: floors, partyStartPosition: startPosition, enemies: enemies)

    func convertFloorPlanToFloorAndStartposition(_ floorplan: String) -> (floor: Floor, startPosition: Coordinate?) {
        let mapArray = convertStringTomapArray(floorplan)
        let floor = Floor(mapArray)
        let startPosition = determineStartPosition(mapArray)

        return (floor, startPosition)
    }
    
    func convertFloorPlanToEnemies(_ floorplan: String) -> Set<Enemy> {
        let mapArray = convertStringTomapArray(floorplan)
        
        var enemiesOnFloor = Set<Enemy>()
        for row in 0 ..< mapArray.count {
            for column in 0 ..< mapArray[row].count {
                switch mapArray[row][column] {
                case "s":
                    enemiesOnFloor.insert(Enemy.makeMeleeEnemy(at: Coordinate(x: column, y: row)))
                case "r":
                    enemiesOnFloor.insert(Enemy.makeRangedEnemy(at: Coordinate(x: column, y: row)))
                case "e":
                    enemiesOnFloor.insert(Enemy.makeMagicEnemy(at: Coordinate(x: column, y: row)))
                default:
                    break
                }
            }
        }
        
        return enemiesOnFloor
    }

    func convertStringTomapArray(_ input: String) -> [[Character]] {
        let lines = input.split(separator: "\n")
        var mapArray = [[Character]]()

        for line in lines {
            var row = [Character]()
            for character in line {
                row.append(character)
            }
            mapArray.append(row)
        }

        return mapArray
    }

    func determineStartPosition(_ mapArray: [[Character]]) -> Coordinate? {
        for row in 0 ..< mapArray.count {
            for column in 0 ..< mapArray[row].count {
                if mapArray[row][column] == "S" {
                    return Coordinate(x: column, y: row)
                }
            }
        }

        return nil
    }
}

enum PartyCommand {
    case move(direction: MovementDirection)
    case turnClockwise
    case turnCounterClockwise
}
