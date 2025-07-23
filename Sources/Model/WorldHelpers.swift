//
//  WorldHelpers.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/07/2025.
//

public func makeWorld(from floorplans: [String]) -> World {
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
                case "p":
                    enemiesOnFloor.insert(Enemy.makePracticeDummy(at: Coordinate(x: column, y: row)))
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

func printMap(map: [Coordinate: Int]) {
    for row in 0 ..< 10 {
        var line = ""
        for column in 0 ..< 10 {
            if let count = map[Coordinate(x: column, y: row)] {
                line += String(count)
            } else {
                line += "."
            }
        }
        print(line)
    }
}
