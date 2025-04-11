import Raylib

let screenWidth: Int32 = 800
let screenHeight: Int32 = 450

Raylib.initWindow(screenWidth, screenHeight, "MyGame")
Raylib.setTargetFPS(30)
let randomColors: [Color] = [.blue, .red, .green, .yellow, .darkBlue, .maroon, .magenta]
var ballColor: Color = .maroon
var ballPosition = Vector2(x: -100, y: -100)
var previousBallPosition: Vector2
while Raylib.windowShouldClose == false {
    // update
    previousBallPosition = ballPosition
    ballPosition = Raylib.getMousePosition()
    if Raylib.isMouseButtonDown(.left) {
        ballColor = randomColors.randomElement() ?? .black
    }
    let size = max(abs(ballPosition.x - previousBallPosition.x) + abs(ballPosition.y - previousBallPosition.y), 10)

    // draw
    Raylib.beginDrawing()
    Raylib.clearBackground(.rayWhite)
    Raylib.drawText("Hello, world!", 425, 25, 25, .darkGray)
    Raylib.drawCircleV(ballPosition, size, ballColor)
    Raylib.drawFPS(10, 10)
    Raylib.endDrawing()
}
Raylib.closeWindow()
