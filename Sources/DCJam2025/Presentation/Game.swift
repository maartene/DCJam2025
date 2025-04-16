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
        
        let visitedTilesOnCurrentFloor = world.visitedTilesOnCurrentFloor
        
        for visitedTilesOnCurrentFloor in visitedTilesOnCurrentFloor {
            let drawTextureInfo = getSpriteAndPositionForTileAtPosition( visitedTilesOnCurrentFloor, on: world.currentFloor, offsetX: minimapOffset, offsetY: minimapOffset)
            if let sprite = sprites[drawTextureInfo.spriteName] {
                Raylib.drawTexture(sprite, drawTextureInfo.displayX, drawTextureInfo.displayY, .white)
            }
        }

        let drawPartyTextureInfo = getSpriteAndPositionForPartyAtPosition(world.partyPosition, heading: world.partyHeading, on: world.currentFloor, offsetX: 10, offsetY: 10)
        
        if let playerSprite = sprites[drawPartyTextureInfo.spriteName] {
            Raylib.drawTexture(playerSprite, drawPartyTextureInfo.displayX, drawPartyTextureInfo.displayY, .white)
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
