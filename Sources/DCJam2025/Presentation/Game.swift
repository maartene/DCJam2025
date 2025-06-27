//
//  Game.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

import Foundation
import raylib

class Game {
    let screenWidth: Int32 = 1280
    let screenHeight: Int32 = 720
    let offset: Float = -0.1

    var camera = makeCamera()

    var sprites = [String: Texture2D]()
    var mockModel: Model!

    let world = makeWorld(from: [
        """
        ######
        #S..##
        #.#..#
        #.##.#
        #s..<#
        ######
        """,
        """
        ######
        #....#
        ##T#.#
        ####.#
        #...>#
        ######        
        """
    ])

    func run() {
        InitWindow(screenWidth, screenHeight, "DCJam2025")
        SetTargetFPS(30)

        loadImages()

        mockModel = loadModel("Skeleton_Warrior", withExtension: "obj")

        while WindowShouldClose() == false {
            update()
            drawGameView()
        }
        CloseWindow()
    }

    private static func makeCamera() -> Camera3D {
        var camera = Camera3D()
        camera.projection = CameraProjection.PERSPECTIVE
        camera.fovy = 60
        camera.up = Vector3(x: 0, y: 1, z: 0)
        return camera
    }

    private func update() {
        world.update(at: Date())
        processKeyInput()
        updateCamera()
    }

    private func processKeyInput() {
        let inputActionMap = [
            KEY_W: { self.world.executeCommand(.move(direction: .forward)) },
            KEY_D: { self.world.executeCommand(.move(direction: .left)) },
            KEY_A: { self.world.executeCommand(.move(direction: .right)) },
            KEY_S: { self.world.executeCommand(.move(direction: .backwards)) },
            KEY_Q: { self.world.executeCommand(.turnClockwise) },
            KEY_E: { self.world.executeCommand(.turnCounterClockwise) }
        ]
        
        for keyAction in inputActionMap {
            if isKeyPressed(keyAction.key) {
                keyAction.value()
            }
        }
    }

    private func updateCamera() {
        let cameraPosition = world.partyPosition.toVector3
        let forward = world.partyHeading.forward
        let target = target(from: world.partyPosition, heading: world.partyHeading)

        camera.target = target.toVector3
        camera.position = cameraPosition + forward.toVector3.scale(offset)
        UpdateCamera(&camera, CameraProjection.PERSPECTIVE)
    }

    private func drawGameView() {
        BeginDrawing()
        ClearBackground(.black)
        draw3D()
        drawMinimap(world: world)
        DrawFPS(10, 400)
        DrawText("\(world.state)", 10, 380, 12, .white)
        drawParty(world.partyMembers)
        EndDrawing()
    }

    private func draw3D() {
        BeginMode3D(camera)
        drawMap(world.currentFloor, vantagePoint: world.partyPosition)
        drawEntities(map: world.currentFloor, vantagePoint: world.partyPosition)
        EndMode3D()
    }

    func drawMap(_ map: Floor, vantagePoint: Coordinate) {
        for row in map.minY...map.maxY {
            for column in map.minX...map.maxX {
                let coordinate = Coordinate(x: column, y: row)
                drawTile(map.tileAt(coordinate), at: coordinate, lookingFrom: vantagePoint)
            }
        }
    }

    private func drawTile(
        _ tile: Tile, at coordinate: Coordinate, lookingFrom vantagePoint: Coordinate
    ) {
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
        DrawCubeV(coordinate.toVector3, .one, .darkGray * light)
    }

    private func drawStairsUpAt(_ coordinate: Coordinate) {
        DrawCubeV(coordinate.toVector3, .one, Color(r: 200, g: 0, b: 0, a: 128))
    }

    private func drawStairsDownAt(_ coordinate: Coordinate) {
        DrawCubeV(coordinate.toVector3, .one, Color(r: 0, g: 200, b: 0, a: 128))
    }

    private func drawTargetAt(_ coordinate: Coordinate) {
        DrawCubeV(coordinate.toVector3, .one, Color(r: 0, g: 0, b: 200, a: 128))
    }

    private func drawEntities(map: Floor, vantagePoint: Coordinate) {
        let enemiesToDraw = world.enemiesOnCurrentFloor
            .filter { $0.isAlive }
        for enemyOnCurrentFloor in enemiesToDraw {
            let coordinate = enemyOnCurrentFloor.position
            let light = light(position: coordinate, vantagePoint: vantagePoint)

            let heading = enemyOnCurrentFloor.heading

            DrawModelEx(mockModel, coordinate.toVector3 + Vector3(x: 0, y: -0.5, z: 0), .up, heading.rotation , Vector3(x: 0.5, y: 0.5, z: 0.5), .white * light)
        }
    }

    private func drawMinimap(world: World) {
        let minimapOffset: Int32 = 10

        let visitedTilesOnCurrentFloor = world.visitedTilesOnCurrentFloor

        for visitedTilesOnCurrentFloor in visitedTilesOnCurrentFloor {
            let drawTextureInfo = getSpriteAndPositionForTileAtPosition(
                visitedTilesOnCurrentFloor, on: world.currentFloor, offsetX: minimapOffset,
                offsetY: minimapOffset)
            if let sprite = sprites[drawTextureInfo.spriteName] {
                DrawTexture(
                    sprite, drawTextureInfo.displayX, drawTextureInfo.displayY, .white)
            }
        }

        let drawPartyTextureInfo = getSpriteAndPositionForPartyAtPosition(
            world.partyPosition, heading: world.partyHeading, on: world.currentFloor, offsetX: 10,
            offsetY: 10)

        if let playerSprite = sprites[drawPartyTextureInfo.spriteName] {
            DrawTexture(
                playerSprite, drawPartyTextureInfo.displayX, drawPartyTextureInfo.displayY, .white)
        }

        let drawEnemyTextureInfo = getSpriteAndPositionForPartyAtPosition(
            world.enemiesOnCurrentFloor.first!.position, heading: world.enemiesOnCurrentFloor.first!.heading, on: world.currentFloor, offsetX: 10,
            offsetY: 10)

        if let enemySprite = sprites[drawEnemyTextureInfo.spriteName] {
            DrawTexture(
                enemySprite, drawEnemyTextureInfo.displayX, drawEnemyTextureInfo.displayY, .red)
        }
    }

    private func drawParty(_ partyMembers: PartyMembers) {
        DrawText("HP: \(partyMembers.getMember(at: .frontLeft).currentHP)", 900, 30, 32, .red)
        if (GuiButton(Rectangle(x: 900, y: 40, width: 100, height: 20), "Attack")) == 1 {
            world.executeCommand(.attack(attacker: .frontLeft))
        }
        DrawText("HP: \(partyMembers.getMember(at: .frontRight).currentHP)", 1100, 30, 32, .red)
        DrawText("HP: \(partyMembers.getMember(at: .backLeft).currentHP)", 900, 60, 32, .red)
        DrawText("HP: \(partyMembers.getMember(at: .backRight).currentHP)", 1100, 60, 32, .red)
    }

    private func loadImages() {
        let imageNames = [
            // Minimap
            "wall",
            "north",
            "south",
            "east",
            "west",
            "stairsUp",
            "stairsDown",
            // Sprites
            "orc"
        ]

        imageNames.forEach {
            guard let textureURL = Bundle.module.url(forResource: $0, withExtension: "png") else {
                fatalError("Could not find \($0).png")
            }

            sprites[$0] = LoadTexture(textureURL.path(percentEncoded: false))
        }
    }

    private func loadModel(_ fileName: String, withExtension ext: String) -> Model {
        guard let modelURL = Bundle.module.url(forResource: fileName, withExtension: ext)
        else {
            fatalError("Could not find file \(fileName) . \(ext)")
        }

        return LoadModel(modelURL.path(percentEncoded: false))
    }
}

extension CompassDirection {
    var rotation: Float {
        switch self {
        case .north:
            return 0
        case .east:
            return 90
        case .south:
            return 180
        case .west:
            return 270
        }
    }
}
