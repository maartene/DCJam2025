//
//  World.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

final class World {
    private(set) var partyPosition: Coordinate
    private(set) var partyHeading: CompassDirection
    private var currentFloorIndex = 0
    private var floors: [Floor]
    
    var currentFloor: Floor {
        floors[currentFloorIndex]
    }
    
    init(floors: [Floor], partyStartPosition: Coordinate = Coordinate(x: 0, y: 0), partyStartHeading: CompassDirection = CompassDirection.north) {
        self.floors = floors
        self.partyPosition = partyStartPosition
        self.partyHeading = partyStartHeading
    }
    
    convenience init(map: Floor, partyStartPosition: Coordinate = Coordinate(x: 0, y: 0), partyStartHeading: CompassDirection = CompassDirection.north) {
        self.init(floors: [map],
             partyStartPosition: partyStartPosition,
             partyStartHeading: partyStartHeading)
    }
    
    func moveParty(_ direction: MovementDirection) {
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
        }
    }
    
    func turnPartyClockwise() {
        partyHeading = partyHeading.rotatedClockwise()
    }
    
    func turnPartyCounterClockwise() {
        partyHeading = partyHeading.rotatedCounterClockwise()
    }
}
