//
//  Game.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

import Raylib
import Foundation

class Game {
    let screenWidth: Int32 = 1280
    let screenHeight: Int32 = 720
    let offset: Float = -0.1
    
    var camera = makeCamera()
    
    var sprites = [String: Texture2D]()
    
    let world = World(floors: [
        Floor([
            ["#","#","#","#","#","#"],
            ["#",".",".",".","#","#"],
            ["#",".","#",".",".","#"],
            ["#",".","#","#",".","#"],
            ["#",".",".",".","<","#"],
            ["#","#","#","#","#","#"],
        ]),
        Floor([
            ["#","#","#","#","#","#"],
            ["#",".",".",".",".","#"],
            ["#","#","T","#",".","#"],
            ["#","#","#","#",".","#"],
            ["#",".",".",".",">","#"],
            ["#","#","#","#","#","#"],
        ]),
    ], partyStartPosition: Coordinate(x: 1, y: 1))
    
    func run() {
        Raylib.initWindow(screenWidth, screenHeight, "DCJam2025")
        Raylib.setTargetFPS(30)

        loadMinimapImages()
                    
        print(Raylib.getWorkingDirectory())
        while Raylib.windowShouldClose == false {
            update()
            drawGameView()
        }
        Raylib.closeWindow()
    }
    
    private static func makeCamera() -> Camera3D {
        var camera = Camera3D()
        camera.projection = .perspective
        camera.fovy = 60
        camera.up = Vector3(x: 0, y: 1, z: 0)
        return camera
    }
    
    private func update() {
        processKeyInput()
        updateCamera()
    }
    
    private func processKeyInput() {
        if Raylib.isKeyPressed(.letterW) {
            world.moveParty(.forward)
        }
        
        if Raylib.isKeyPressed(.letterD) {
            world.moveParty(.right)
        }
        
        if Raylib.isKeyPressed(.letterA) {
            world.moveParty(.left)
        }
        
        if Raylib.isKeyPressed(.letterS) {
            world.moveParty(.backwards)
        }
        
        if Raylib.isKeyPressed(.letterQ) {
            world.turnPartyClockwise()
        }
        
        if Raylib.isKeyPressed(.letterE) {
            world.turnPartyCounterClockwise()
        }
    }
    
    private func updateCamera() {
        let cameraPosition = world.partyPosition.toVector3
        let forward = world.partyHeading.forward
        let target = target(from: world.partyPosition, heading: world.partyHeading)
        
        camera.target = target.toVector3
        camera.position = cameraPosition + forward.toVector3.scale(offset)
        Raylib.updateCamera(&camera)
    }

    private func drawGameView() {
        Raylib.beginDrawing()
            Raylib.clearBackground(.black)
            draw3D()
        drawMinimap(world: world)
            Raylib.drawFPS(10, 400)
            Raylib.drawText("\(world.state)", 10, 380, 12, .white)
        Raylib.endDrawing()
    }

    private func draw3D() {
        Raylib.beginMode3D(camera)
        drawMap(world.currentFloor, vantagePoint: world.partyPosition)
        Raylib.endMode3D()
    }
    
    func drawMap(_ map: Floor, vantagePoint: Coordinate) {
        for row in map.minY ... map.maxY {
            for column in map.minX ... map.maxX {
                let coordinate = Coordinate(x: column, y: row)
                drawTile(map.tileAt(coordinate), at: coordinate, lookingFrom: vantagePoint)
            }
        }
    }
    
    private func drawTile(_ tile:Tile, at coordinate: Coordinate, lookingFrom vantagePoint: Coordinate) {
        switch tile {
        case .wall:
            drawWallAt(coordinate, vantagePoint: vantagePoint)
        case .stairsUp:
            drawStairsUpAt(coordinate)
        case .stairsDown:
            drawStairsDownAt(coordinate)
        case .target:
            drawTargetAt(coordinate)
        default:
            break
        }
    }
    
    private func drawWallAt(_ coordinate: Coordinate, vantagePoint: Coordinate) {
        let light = light(position: coordinate, vantagePoint: vantagePoint)
        Raylib.drawCubeV(coordinate.toVector3, .one, Color.darkGray * light)
    }
    
    private func drawStairsUpAt(_ coordinate: Coordinate) {
        Raylib.drawCubeV(coordinate.toVector3, .one, Color(r: 200, g: 0, b: 0, a: 128))
    }
    
    private func drawStairsDownAt(_ coordinate: Coordinate) {
        Raylib.drawCubeV(coordinate.toVector3, .one, Color(r: 0, g: 200, b: 0, a: 128))
    }
    
    private func drawTargetAt(_ coordinate: Coordinate) {
        Raylib.drawCubeV(coordinate.toVector3, .one, Color(r: 0, g: 0, b: 200, a: 128))
    }
    
    private func drawMinimap(world: World) {
        let minimapOffset: Int32 = 10
        let spriteSize: Int32 = 16
        
        let maxX = world.currentFloor.maxX
        let maxY = world.currentFloor.maxY
        
        let visitedTilesOnCurrentFloor: [(coordinate: Coordinate, tile: Tile)] = world.visitedTilesOnCurrentFloor.map {
            ($0, world.currentFloor.tileAt($0))
        }
        
        let tileToSpriteMap: [Tile: String] = [
            .wall: "wall",
            .stairsDown: "stairsDown",
            .stairsUp: "stairsUp",
        ]
        
        for visitedTilesOnCurrentFloor in visitedTilesOnCurrentFloor {
            let correctedX = Int32(maxX - visitedTilesOnCurrentFloor.coordinate.x) * spriteSize + minimapOffset
            let correctedY = Int32(maxY - visitedTilesOnCurrentFloor.coordinate.y) * spriteSize + minimapOffset
            
            if let spriteName = tileToSpriteMap[visitedTilesOnCurrentFloor.tile], let sprite = sprites[spriteName] {
                Raylib.drawTexture(sprite, correctedX, correctedY, .white)
            }
        }
        
        let playerDirectionSymbol = playerDirectionSymbol(heading: world.partyHeading)
        
        if let playerSprite = sprites[playerDirectionSymbol] {
            let correctedX = Int32(maxX - world.partyPosition.x) * spriteSize + minimapOffset
            let correctedY = Int32(maxY - world.partyPosition.y) * spriteSize + minimapOffset
            Raylib.drawTexture(playerSprite, correctedX, correctedY, .white)
        }
    }
    
    private func playerDirectionSymbol(heading: CompassDirection) -> String {
        switch heading {
            
        case .north: "north"
        case .east: "west"
        case .south: "south"
        case .west: "east"
        }
        
    }
    
    private func loadMinimapImages() {
        let minimapImageNames = [
            "wall",
            "north",
            "south",
            "east",
            "west",
            "stairsUp",
            "stairsDown",
        ]
        
        minimapImageNames.forEach {
            guard let url = Bundle.module.url(forResource: $0, withExtension: "png") else {
                fatalError("Could not find \($0).png")
            }
            
            sprites[$0] = Texture(url: url)
        }
    }
}
