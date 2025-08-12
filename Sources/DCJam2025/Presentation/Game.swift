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

    let rlHelper = RayLibStateHelper()

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
        SetConfigFlags(FLAG_MSAA_4X_HINT.rawValue)
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
        rlHelper.withDrawing {
            ClearBackground(.black)

            draw3D()

            drawMinimap(world: world)
            DrawFPS(10, 400)
            DrawText("\(world.state)", 10, 380, 12, .white)

            drawGUI()
        }
    }

    private func draw3D() {
        var drawables = floorToDrawables(world.currentFloor)

        let enemyDrawables = world.enemiesOnCurrentFloor
            .filter { $0.isAlive }
            .flatMap { Drawable3D.makeEntity($0) }

        drawables.append(contentsOf: enemyDrawables)

        rlHelper.with3DDrawing(camera: camera) {
            rlHelper.withShader(shader) {
                drawables.forEach(draw)
            }
        }
    }

    private func draw(_ drawable: Drawable3D) {
        if let model = models[drawable.modelName] {
            DrawModelEx(
                model,
                drawable.position,
                drawable.up,
                drawable.rotation,
                drawable.scale,
                drawable.tint
            )
        }
    }

    private func drawMinimap(world: World) {
        minimap(for: world, minimapOffset: 10)
            .forEach { draw($0) }
    }

    private func draw(_ drawable: Drawable2D) {
        if let sprite = sprites[drawable.spriteName] {
            DrawTextureV(
                sprite, drawable.position, drawable.tint)
        }
    }

    func drawGUI() {
        GUI(world: world, sprites: sprites).drawParty()
            .forEach {
                $0.draw()
            }
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
                                fragURL.path(percentEncoded: false))
        // Get some required shader locations
        shader.locs[11] = GetShaderLocation(shader, "viewPos")

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
            "ceiling_tile",
            "chest_gold",
            "shadow"
        ]

        modelNames.forEach {
            models[$0] = loadModel($0, withExtension: "obj")
        }
    }

    private func loadModel(_ fileName: String, withExtension ext: String) -> Model {
        let shaderOverrideSlot = [
            "Skeleton_Warrior": 1,
            "shadow": 1
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
