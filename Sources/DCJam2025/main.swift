import Raylib

let screenWidth: Int32 = 800
let screenHeight: Int32 = 450

Raylib.initWindow(screenWidth, screenHeight, "DCJam2025")
Raylib.setTargetFPS(30)

let world = World(map: Map([
    ["#","#","#","#","#","#"],
    ["#",".",".",".","#","#"],
    ["#",".","#",".",".","#"],
    ["#",".","#","#",".","#"],
    ["#",".",".",".",".","#"],
    ["#","#","#","#","#","#"],
]), partyStartPosition: Coordinate(x: 1, y: 1))

var camera = Camera3D()
camera.projection = .perspective
camera.fovy = 60
camera.up = Vector3(x: 0, y: 1, z: 0)
camera.position = Vector3(x: 1, y: 0, z: 1)
camera.target = Vector3(x: 2, y: 0, z: 1)

while Raylib.windowShouldClose == false {
    // update
    Raylib.updateCamera(&camera)

    // draw
    Raylib.beginDrawing()
    Raylib.clearBackground(.darkGray)
    Raylib.beginMode3D(camera)
        for row in world.map.minY ... world.map.maxY {
            for column in world.map.minX ... world.map.maxX {
                let coordinate = Coordinate(x: column, y: row)
                if world.map.tileAt(coordinate) == .wall {
                    Raylib.drawCubeV(coordinate.toVector3, .one, .blue)
                }
            }
        }
    Raylib.endMode3D()
    
    Raylib.drawFPS(10, 10)
    Raylib.endDrawing()
}
Raylib.closeWindow()

extension Coordinate {
    var toVector3: Vector3 {
        Vector3(x: Float(x), y: 0, z: Float(y))
    }
}
