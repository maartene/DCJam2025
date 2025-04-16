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
    
    var minX: Int {
        tiles.keys.map { $0.x }.min() ?? 0
    }
    
    var minY: Int {
        tiles.keys.map { $0.y }.min() ?? 0
    }
    
    var maxX: Int {
        tiles.keys.map { $0.x }.max() ?? 0
    }
    
    var maxY: Int {
        tiles.keys.map { $0.y }.max() ?? 0
    }
    
    init(_ mapArray: [[Character]] = [[]]) {
        var readTiles = [Coordinate: Tile]()
        for row in 0 ..< mapArray.count {
            for column in 0 ..< mapArray[0].count {
                readTiles[Coordinate(x: column, y: row)] = Tile.characterToTile(mapArray[row][column])
            }
        }
        
        self.tiles = readTiles.filter { $0.value != .floor }
    }
    
    func tileAt(_ coordinate: Coordinate) -> Tile {
        tiles[coordinate, default: .floor]
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
