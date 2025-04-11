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
    var camera = makeCamera()
    
    let world = World(map: Map([
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
    
    private func updateCamera() {
        camera.position = world.partyPosition.toVector3
        camera.target = camera.position + Vector3(x: 0, y: 0, z: 1)
        Raylib.updateCamera(&camera)
    }
    
    private func processKeyInput() {
        if Raylib.isKeyPressed(.letterW) {
            world.moveParty(.forward)
        }
    }

    private func drawGameView() {
        Raylib.beginDrawing()
            Raylib.clearBackground(.darkGray)
            draw3D()
            Raylib.drawFPS(10, 10)
        Raylib.endDrawing()
    }

    func drawMap(_ map: Map, vantagePoint: Coordinate) {
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
    
    private func draw3D() {
        Raylib.beginMode3D(camera)
        drawMap(world.map, vantagePoint: world.partyPosition)
        Raylib.endMode3D()
    }
}
