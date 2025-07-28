[![Swift](https://github.com/maartene/DCJam2025/actions/workflows/swift.yml/badge.svg)](https://github.com/maartene/DCJam2025/actions/workflows/swift.yml)

# DCJam2025
Started of as an entry for [Dungeon Crawler jam 2025](https://itch.io/jam/dcjam2025) but evolved into its own game.

## About the game
### Backstory

### How to play?
- WASD to move, Q and E to rotate counterclockwise and clockwise

## Installation
### Swift toolchain
You need a Swift toolchain. You can install Swift from here.

### Raylib
* macOS: easiest install is using homebrew: `# brew install raylib`
* linux: depends on distro. See the [instructions](https://github.com/raysan5/raylib/wiki/Working-on-GNU-Linux). Make sure that the library files (`libraylib.a`, `libraylib.so`, `libraylib.so.5.5.0`, `libraylib.so.550`) are in a path where the Swift toolchain can find them (for example: `/usr/lib`)

### Build & Run
When you have the toolchain installed, clone the repo. Then build project:
`# swift build` 

Its wise to then run the tests:
`# swift test`

Run the project using:
`# swift run`
 
## Supported platforms
* macOS
* Linux (tested: Ubuntu 22.04 on WSL)

## License
* Contains [raylib by Ramon Santamaria (Zlib license)](https://github.com/raysan5/raylib). 
* Contains [raygui by Ramon Santamaria (Zlib license)](https://github.com/raysan5/raygui). 
* Contains [KayKit - Character Pack : Skeletons](https://kaylousberg.itch.io/kaykit-skeletons)
* Contains [KayKit - Dungeon Remastered Pack](https://kaylousberg.itch.io/kaykit-dungeon-remastered)
* Contains placeholder Skeleton image from [Tiny RPG Character Asset Pack v1.03](https://zerie.itch.io/tiny-rpg-character-asset-pack)
* Copyright 2025, Maarten Engels - thedreamweb.eu
