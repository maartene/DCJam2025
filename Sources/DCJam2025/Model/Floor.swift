//
//  Map.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

enum Tile: Character {
    case floor = "."
    case wall = "#"
    case stairsUp = "<"
    case stairsDown = ">"
    case target = "T"

    static func characterToTile(_ character: Character) -> Tile {
        Tile(rawValue: character) ?? .floor
    }
}

struct Floor {
    private var tiles = [Coordinate: Tile]()

    let minX: Int
    let minY: Int
    let maxX: Int
    let maxY: Int

    init(_ mapArray: [[Character]] = [[]]) {
        var readTiles = [Coordinate: Tile]()
        
        for row in 0 ..< mapArray.count {
            for column in 0 ..< mapArray[0].count {
                readTiles[Coordinate(x: column, y: row)] = Tile.characterToTile(mapArray[row][column])
            }
        }

        self.tiles = readTiles.filter { $0.value != .floor }

        minX = 0
        minY = 0
        maxX = (mapArray.first?.count ?? 1) - 1
        maxY = mapArray.count - 1
    }

    func tileAt(_ coordinate: Coordinate) -> Tile {
        tiles[coordinate, default: .floor]
    }
    
    func BFS(from start: Coordinate, to destination: Coordinate) -> [Coordinate: Int] {
        // Queue for BFS and a set to keep track of visited points (including their distance)
        var queue: [(Coordinate, Int)] = [(start, 0)]  // (current point, distance)
        var visited = [start : 0]

        while queue.isEmpty == false {
            let (current, distance) = queue.removeFirst()

            // Check if current point is the destination
            if current == destination {
                return visited
            }

            // Try to move in all directions
            for neighbour in current.neighbours {
                // Check if its within grid and not an occupied location
                if visited.keys.contains(neighbour) == false &&
                    isWithinFloor(neighbour) &&
                    tileAt(neighbour) == .floor
                {
                    let distanceForNeighbour = distance + 1
                    queue.append((neighbour, distanceForNeighbour))
                    visited[neighbour] = distanceForNeighbour
                }
            }
        }
        
        return [:]
    }
    
    func getPath(from start: Coordinate, to destination: Coordinate, using map: [Coordinate: Int]) -> [Coordinate] {
        var result = [Coordinate]()
        
        guard map.keys.contains(start), map.keys.contains(destination) else {
            return []
        }

        var current = destination
        while current != start {
            let neighbourDistances = current.neighbours
                .compactMap { ($0, map[$0]) }
            
            guard let newCurrent = neighbourDistances.min(by: { $0.1 ?? Int.max < $1.1 ?? Int.max }) else {
                return []
            }
            
            result.append(current)
            
            current = newCurrent.0
        }
        
        return result.reversed()
    }
    
    private func isWithinFloor(_ coordinate: Coordinate) -> Bool {
        coordinate.x >= minX && coordinate.y >= minY && coordinate.x <= maxX && coordinate.y <= maxY
    }
}

extension Floor: Equatable { }

extension Floor: CustomStringConvertible {
    var description: String {
        var lines = [String]()
        for y in minY ... maxY {
            var line = ""
            for x in minX ... maxX {
                line += String(tileAt(Coordinate(x: x, y: y)).rawValue)
            }
            lines.append(line)
        }
        return lines.joined(separator: "\n")
    }
}
