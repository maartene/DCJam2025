//
//  Game.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

import Raylib

class Game {
    let screenWidth: Int32 = 800
    let screenHeight: Int32 = 450
    let offset: Float = -0.1
    
    var camera = makeCamera()
    
    let world = World(map: Floor([
        ["#","#","#","#","#","#"],
        ["#",".",".",".","#","#"],
        ["#",".","#",".",".","#"],
        ["#",".","#","#",".","#"],
        ["#",".",".",".",".","#"],
        ["#","#","#","#","#","#"],
    ]), partyStartPosition: Coordinate(x: 1, y: 1))
    
    func run() {
        Raylib.initWindow(screenWidth, screenHeight, "DCJam2025")
        Raylib.setTargetFPS(30)

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
        let forward = MovementDirection.forward.toCompassDirection(facing: world.partyHeading).toCoordinate
        let target = world.partyPosition + forward
        
        camera.target = target.toVector3
        camera.position = cameraPosition + forward.toVector3.scale(offset)
        Raylib.updateCamera(&camera)
    }

    private func drawGameView() {
        Raylib.beginDrawing()
            Raylib.clearBackground(.darkGray)
            draw3D()
            Raylib.drawFPS(10, 10)
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
                if map.tileAt(coordinate) == .wall {
                    let light = light(position: coordinate, vantagePoint: vantagePoint)
                    Raylib.drawCubeV(coordinate.toVector3, .one, Color.gray * light)
                }
            }
        }
    }
}
