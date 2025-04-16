//
//  World.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

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
    
    // Initializers
    init(floors: [Floor], partyStartPosition: Coordinate = Coordinate(x: 0, y: 0), partyStartHeading: CompassDirection = CompassDirection.north) {
        self.floors = floors
        self.partyPosition = partyStartPosition
        self.partyHeading = partyStartHeading
        
        updateVisitedTiles()
    }
    
    convenience init(map: Floor, partyStartPosition: Coordinate = Coordinate(x: 0, y: 0), partyStartHeading: CompassDirection = CompassDirection.north) {
        self.init(floors: [map],
             partyStartPosition: partyStartPosition,
             partyStartHeading: partyStartHeading)
    }
    
    // Queries
    var currentFloor: Floor {
        floors[currentFloorIndex]
    }
    
    var state: WorldState {
        if currentFloor.tileAt(partyPosition) == .target {
            return .won
        }
        
        return .inProgress
    }
    
    var visitedTilesOnCurrentFloor: Set<Coordinate> {
        visitedTilesOnFloor[currentFloorIndex, default: []]
    }
    
    // MARK: Commands
    func moveParty(_ direction: MovementDirection) {
        guard state != .won else {
            return
        }
        
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
    
    func turnPartyClockwise() {
        partyHeading = partyHeading.rotatedClockwise()
    }
    
    func turnPartyCounterClockwise() {
        partyHeading = partyHeading.rotatedCounterClockwise()
    }
    
    private func updateVisitedTiles() {
        visitedTilesOnFloor[currentFloorIndex] = visitedTilesOnCurrentFloor.union(partyPosition.squareAround)
    }
}

extension World: Equatable {
    static func == (lhs: World, rhs: World) -> Bool {
        lhs.partyPosition == rhs.partyPosition &&
        lhs.partyHeading == rhs.partyHeading &&
        lhs.floors == rhs.floors && 
        lhs.currentFloorIndex == rhs.currentFloorIndex
    }
}

func makeWorld(from floorplans: [String]) -> World {
    let convertedFloorplans = floorplans.map { convertFloorPlanToFloorAndStartposition($0) }
    
    let floors = convertedFloorplans.map { $0.floor }
    let startPosition = convertedFloorplans
        .compactMap { $0.startPosition }
        .first ?? Coordinate(x: 0, y: 0)
    
    return World(floors: floors, partyStartPosition: startPosition)
    
    func convertFloorPlanToFloorAndStartposition(_ floorplan: String) -> (floor: Floor, startPosition: Coordinate?) {
        let mapArray = convertStringTomapArray(floorplan)
        let floor = Floor(mapArray)
        let startPosition = determineStartPosition(mapArray)
        
        return (floor, startPosition)
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
