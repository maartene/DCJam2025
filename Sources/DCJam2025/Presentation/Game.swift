//
//  Game.swift
//  DCJam2025
//
//  Created by Maarten Engels on 11/04/2025.
//

import Foundation
import raylib
import Model

class Game {
    let screenWidth: Int32 = 1280
    let screenHeight: Int32 = 720
    let offset: Float = -0.1

    var camera = makeCamera()

    var sprites = [String: Texture2D]()
    var models = [String: Model]()

    var pointLight: Light!
    var shader: Shader!
    
    let world = makeWorld(from: [
        """
        #######
        #S....#
        #.....#
        #..<..#
        #######
        """,
        """
        #################
        #.........s.....#
        #....######.#####
        #..>.#......#...#
        ######..s.......#
        #......######...#
        #..####....##...#
        #.s.....<.....s.#
        #################
        """,
        """
        ###############################
        #............s#...........#.T.#        
        ###.###.#########.#.....#.#...#        
        #.....#.#.s.....s.#.....#.##.##        
        #.s...#.#.........#######...s.#        
        #.....#.###.#######.....#######        
        #...###...#.............#.....#        
        #.###.#.>.#.#############.....#        
        #.....#...#.....s.......###...#        
        #.....#####.#######.###.......#        
        #............#..s.....#########        
        ############.#........#....#..#        
        #..........#.####...#.#.s.....#        
        #..s.....s.#....#...#.........#        
        #..........#.#..#...#.#....#..#        
        ###############################
        """
    ])

    func run() {
        InitWindow(screenWidth, screenHeight, "DCJam2025")
        SetTargetFPS(60)

        shader = loadShader()
        
        loadImages()
        loadModels()
        
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
        updateLights()
    }

    private func processKeyInput() {
        let inputActionMap = [
            KEY_W: { self.world.executeCommand(.move(direction: .forward), at: Date()) },
            KEY_D: { self.world.executeCommand(.move(direction: .left), at: Date()) },
            KEY_A: { self.world.executeCommand(.move(direction: .right), at: Date()) },
            KEY_S: { self.world.executeCommand(.move(direction: .backwards), at: Date()) },
            KEY_Q: { self.world.executeCommand(.turnClockwise, at: Date()) },
            KEY_E: { self.world.executeCommand(.turnCounterClockwise, at: Date()) }
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
    
    private func updateLights() {
        pointLight = CreateLight(Int32(LIGHT_POINT.rawValue), camera.position, Vector3(x: 0, y: 0, z: 0), Color(r: 200, g: 150, b: 100, a: 255) * 0.8, shader, 0)
        
        SetShaderValue(shader, shader.locs[Int(SHADER_LOC_VECTOR_VIEW.rawValue)], [camera.position.x, camera.position.y, camera.position.z], Int32(SHADER_UNIFORM_VEC3.rawValue))
        UpdateLightValues(shader, pointLight)
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

        BeginShaderMode(shader);
            drawMap(world.currentFloor, vantagePoint: world.partyPosition)
            drawEntities(map: world.currentFloor, vantagePoint: world.partyPosition)
        EndShaderMode();

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
            drawStairsUpAt(coordinate, vantagePoint: vantagePoint)
        case .stairsDown:
            drawStairsDownAt(coordinate, vantagePoint: vantagePoint)
        case .target:
            drawTargetAt(coordinate)
        default:
            drawFloorAt(coordinate, vantagePoint: vantagePoint)
            drawCeilingAt(coordinate, vantagePoint: vantagePoint)
        }
    }

    private func drawWallAt(_ coordinate: Coordinate, vantagePoint: Coordinate) {
        guard let wallModel = models["wall"] else {
            return
        }

        DrawModelEx(wallModel, coordinate.toVector3, .up, 0, Vector3(x: 0.25, y: 0.25, z: 0.25), .white)
    }

    private func drawStairsUpAt(_ coordinate: Coordinate, vantagePoint: Coordinate) {
        guard let stairsModel = models["stairs"] else {
            return
        }
        
        DrawModelEx(stairsModel, coordinate.toVector3 + Vector3(x: 0, y: -0.5, z: 0.5), .up, 180, Vector3(x: 0.25, y: 0.25, z: 0.25), .white)
    }

    private func drawStairsDownAt(_ coordinate: Coordinate, vantagePoint: Coordinate) {
        guard let stairsModel = models["stairs"] else {
            return
        }

        DrawModelEx(stairsModel, coordinate.toVector3 + Vector3(x: 0, y: -1.5, z: 0.5), .up, 180, Vector3(x: 0.25, y: 0.25, z: 0.25), .white)
        drawCeilingAt(coordinate, vantagePoint: vantagePoint)
    }

    private func drawTargetAt(_ coordinate: Coordinate) {
        DrawCubeV(coordinate.toVector3, .one, Color(r: 0, g: 0, b: 200, a: 128))
    }

    private func drawFloorAt(_ coordinate: Coordinate, vantagePoint: Coordinate) {
        guard let floorModel = models["floor_wood_large"] else {
            return
        }

        DrawModelEx(floorModel, coordinate.toVector3 + Vector3(x: 0, y: -0.5, z: 0), .up, 0, Vector3(x: 0.25, y: 0.25, z: 0.25), .white)
    }
    
    private func drawCeilingAt(_ coordinate: Coordinate, vantagePoint: Coordinate) {
        guard let ceilingModel = models["ceiling_tile"] else {
            return
        }

        let rotation: Float = coordinate.y.isMultiple(of: 2) || coordinate.x.isMultiple(of: 2) ? 0 : 90
        
        DrawModelEx(ceilingModel, coordinate.toVector3 + Vector3(x: 0, y: 0.5, z: 0), .init(x: 0, y: 1, z: 0), rotation, Vector3(x: 0.25, y: 0.25, z: 0.25), .white)
    }

    private func drawEntities(map: Floor, vantagePoint: Coordinate) {
        let enemiesToDraw = world.enemiesOnCurrentFloor
            .filter { $0.isAlive }
        for enemyOnCurrentFloor in enemiesToDraw {
            let coordinate = enemyOnCurrentFloor.position

            let heading = enemyOnCurrentFloor.heading
            
            guard let mockModel = models["Skeleton_Warrior"] else {
                return
            }
            
            DrawModelEx(mockModel, coordinate.toVector3 + Vector3(x: 0, y: -0.5, z: 0), .up, heading.rotation, Vector3(x: 0.5, y: 0.5, z: 0.5), .white)
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

        let visibleEnemies = world.aliveEnemiesOnCurrentFloor
            .filter { world.currentFloor.hasUnobstructedView(from: world.partyPosition, to: $0.position) }

        for enemy in visibleEnemies {
            let drawEnemyTextureInfo = getSpriteAndPositionForPartyAtPosition(
                enemy.position, heading: enemy.heading, on: world.currentFloor, offsetX: 10,
                offsetY: 10)

            if let enemySprite = sprites[drawEnemyTextureInfo.spriteName] {
                DrawTexture(
                    enemySprite, drawEnemyTextureInfo.displayX, drawEnemyTextureInfo.displayY, .red)
            }
        }
    }

    private func drawParty(_ partyMembers: PartyMembers) {
        GuiSetState(GuiState.normal)

        drawPartyMember(.frontLeft, position: Vector2(x: 890, y: 10))
        drawPartyMember(.frontRight, position: Vector2(x: 890 + 185 + 10, y: 10))
        drawPartyMember(.backLeft, position: Vector2(x: 890, y: 170))
        drawPartyMember(.backRight, position: Vector2(x: 890 + 185 + 10, y: 170))
    }

    private func drawPartyMember(_ memberPosition: SinglePartyPosition, position: Vector2) {
        let partyMember = world.partyMembers[memberPosition]
        let x = Int32(position.x)
        let y = Int32(position.y)
        let fontSize: Int32 = 24
        
        DrawRectangle(x, y, 185, 150, .darkGray)
        
        DrawText(partyMember.name, x + 5, y, fontSize, .white)
        
        if let portrait = sprites[partyMember.name] {
            DrawTexture(portrait, x + 5, y + 25, .white)
        }
        
        let attackButtonSize = Vector2(x: 70, y: 40)
        
        drawAttackButtonFor(memberPosition, hand: .primary, position: position + Vector2(x: 5 + 100 + 5, y: 25), size: attackButtonSize)
        drawAttackButtonFor(memberPosition, hand: .secondary, position: position + Vector2(x: 5 + 100 + 5, y: 25 + attackButtonSize.y), size: attackButtonSize)
        
        drawHPBar(currentHP: partyMember.currentHP, maxHP: 10, position: position + Vector2(x: 5, y: 130))
    }

    private func drawAttackButtonFor(_ memberPosition: SinglePartyPosition, hand: PartyMember.Hand, position: Vector2, size: Vector2) {
        let saveGuiState = GuiGetState()
        let buttonRectangle = Rectangle(x: position.x, y: position.y, width: size.x, height: size.y)
        let partyMember = world.partyMembers[memberPosition]
        let attackName = partyMember.weaponForHand(hand: hand).name
        
        if partyMember.canExecuteAbility(for: hand, at: Date()) {
            if (GuiButton(buttonRectangle, attackName)) == 1 {
                world.executeCommand(.executeHandAbility(user: memberPosition, hand: hand), at: Date())
            }
        } else {
            GuiSetState(GuiState.disabled)
            GuiButton(buttonRectangle, attackName)
        }
        GuiSetState(saveGuiState)
    }
    
    private func drawHPBar(currentHP: Int, maxHP: Int, position: Vector2) {
        // label:
        let x = Int32(position.x)
        let y = Int32(position.y)
        DrawText("HP: ", x, y, 16, .white)
        
        // outer bar:
        DrawRectangleV(position + Vector2(x: 30, y: 0), Vector2(x: 145, y: 15), .white)
        
        // inner bar:
        let maxWidth: Float = 145 - 4
        let size = Float(currentHP) / Float(maxHP) * maxWidth
        
        DrawRectangleV(position + Vector2(x: 30 + 2, y: 2), Vector2(x: size, y: 15 - 4), hpBarColor(currentHP: currentHP, maxHP: maxHP))
    }
    
    private func loadShader() -> Shader {
        guard let fragURL = Bundle.module.url(forResource: "lighting", withExtension: "fs")
        else {
            fatalError("Could not find file lighting.fs")
        }

        guard let vertexURL = Bundle.module.url(forResource: "lighting", withExtension: "vs")
        else {
            fatalError("Could not find file lighting.vs")
        }

        // Load basic lighting shader
        let shader = LoadShader(vertexURL.path(percentEncoded: false),
                                fragURL.path(percentEncoded: false));
        // Get some required shader locations
        shader.locs[11] = GetShaderLocation(shader, "viewPos");
        
        return shader
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
            "orc",
            "Loretta",
            "Ludo",
            "Lenny",
            "Leroy"
        ]

        imageNames.forEach {
            guard let textureURL = Bundle.module.url(forResource: $0, withExtension: "png") else {
                fatalError("Could not find \($0).png")
            }

            sprites[$0] = LoadTexture(textureURL.path(percentEncoded: false))
        }
    }
    
    private func loadModels() {
        let modelNames = [
            "Skeleton_Warrior",
            "stairs",
            "wall",
            "floor_wood_large",
            "ceiling_tile"
        ]
                
        modelNames.forEach {
            models[$0] = loadModel($0, withExtension: "obj")
        }
    }

    private func loadModel(_ fileName: String, withExtension ext: String) -> Model {
        let shaderOverrideSlot = [
            "Skeleton_Warrior": 1
        ]
        
        guard let modelURL = Bundle.module.url(forResource: fileName, withExtension: ext)
        else {
            fatalError("Could not find file \(fileName) . \(ext)")
        }

        let model = LoadModel(modelURL.path(percentEncoded: false))
        let shaderSlot = shaderOverrideSlot[fileName, default: 0]
        model.materials[shaderSlot].shader = shader
        return model
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
