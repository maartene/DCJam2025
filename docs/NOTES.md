# Pomodoro Technique - 📝 Notes from the journey 🍅 by 🍅

## 🏷️ Labels

- ✅ done
- 🚧 WIP
- ❌ ERROR
- ⚠️ TODO

## My rules

- All domain logic should be covered by tests

## Story
You breached the first level of security. Now its you job to hack through the next 10 levels of security.
What is there to find? The answer to the ultimate secret: what came before? the chicken of the egg?
### Themes: 
    - hacking fits a **heist** setup well, get loot. also, literally hacking a firewall could be fun :)
    - treasure hunting: fake walls? secrets on maps?
### Restriction:
    - The secret to find is the answer to the question what came first, the chicken or the egg.


## 🍅 Pomodoro 1
- ✅ Bring in basic movement logic
- ✅ First pass of visualizer
- ✅ 'Lighting'

## 🍅 Pomodoro 2
- ✅ Multiple floors
    - ✅ visualize multiple floors
        - ✅ storing multiple floors in World
        - ✅ Make `currentFloorInde` private
            - ✅ Have tests check for equality of currentFloor instead of index
                - ✅ Floor should conform to equatable
    
## 🍅 Pomodoro 3
- ✅ Add tests for coordinate space conversions

## 🍅 Pomodoro 4
- ✅ Create a nicer 'importer' of levels

## 🍅 Pomodoro 5
- ✅ Win condition added: find the treasure
- ✅ Stub for visual representation of state

## 🍅 Pomodoro 6
- ✅ Visited tiles on first floor
- ✅ Very simple minimap

## 🍅 Pomodoro 7
- ✅ Graphical minimap

## 🍅 Pomodoro 8
- ✅ Visited tiles on multiple floors
- ✅ Add some missing tests for conversions

## 🍅 Pomodoro 9
- ✅ Basic lose condition in game
- 🚧 Enemies attack players

## 🍅 Pomodoro 10
- ✅ an enemy sprite in the world (static sprite)

## 🍅 Pomodoro 11
- ✅ a model in the world (unlit, but with texture)

## 🍅 Pomodoro 12, 13 and 14
- ✅ wrangle Raylib C version, so we can use the latest Raylib version
- ✅ export single frame from Blender for Skeleton

## 🍅 Pomodoro 15
- ✅ replace manual url string manipulation with Foundation function
- ✅ solve tech debt entries

## 🍅 Pomodoro 16
- ✅ Cooldown for enemies
- ✅ Add update cycle to game
- ✅ Show HP on screen

## 🍅 Pomodoro 17
- ✅ Ranged enemies can attack back row
- ✅ Ranged enemies can attack further away

## 🍅 Pomodoro 18
- ✅ Magic numbers in Enemy.swift
- ✅ Factory methods for enemy types
- ✅ Ranged enemies do less damage than melee enemies

## 🍅 Pomodoro 19
- ✅ Enemies have heading
- ✅ And take this into account when attacking

## 🍅 Pomodoro 20
- ✅ Migrate Enemy from inheritance to Strategy pattern

## 🍅 Pomodoro 21
- ✅ Implement magic enemies
- 🚧 Enemy movement
    - ✅ Just move forward
    - ⚠️ Path finding

## 🍅 Pomodoro 22
- 🚧 Enemy movement
    - ⚠️ Path finding
        - ✅ Fake it
        - ⚠️ Proper path finding

## 🍅 Pomodoro 23
- ✅ Enemy movement
    - ✅ Path finding
        - ✅ Fake it
        - ✅ Proper path finding

## 🍅 Pomodoro 24
- 🚧 Party members can attack
    - Simple melee attack from 'the party' (to show damaging enemies)
    - Specific party member attacks
        - Taking cooldown into account
        - Left and right arms
    - Specific party member attacks with ranged attack
- ⚠️ Manage enemy health
    - ✅ Take damage
    - State: alive or dead

## 🍅 Pomodoro 25
- 🚧 Party members can attack
    - ✅ Simple melee attack from 'the party' (to show damaging enemies)
    - Specific party member attacks
        - 🚧 Melee attacks are only possible from the front row
            - ✅ Can attack from front-row
            - Cannot attack from other row
        - Melee attacks have a range
        - Taking cooldown into account
        - Left and right arms
    - Specific party member attacks with ranged attack
- ⚠️ Manage enemy health
    - ✅ Take damage
    - State: alive or dead

## 🍅 Pomodoro 26
- 🚧 Party members can attack
    - ✅ Simple melee attack from 'the party' (to show damaging enemies)
    - Specific party member attacks
        - ✅ Melee attacks are only possible from the front row
            - ✅ Can attack from front-row
            - ✅ Cannot attack from other row
        - ✅ Melee attacks have a range
        - Taking cooldown into account
        - Left and right arms
    - Specific party member attacks with ranged attack
- ✅ Manage enemy health
    - ✅ Take damage
    - ✅ State: alive or dead
- ✅ Use regular enums instead of keypaths to determine party member(s)
- ✅ Party member frontLeft can attack

## 🍅 Pomodoro 27
- ✅ Subscript `PartyMembers`
- ✅ Cooldown for party attacks
- ✅ Show cooldown in game view

## 🍅 Pomodoro 28
- ✅ KOd party members cannot attack
- ✅ Remove @testable import from tests
- ✅ Move into Model seperate package

## 🍅 Pomodoro 29 and 30
- ✅ Improved the look of party members: portraits, health bars and multiple buttons
- ✅ Add ability for partymembers to be ranged or magic

## 🍅 Pomodoro 31
- ✅ Two hands!
    - ✅ Act indipendently
    - ✅ Their own cooldown

## 🍅 Pomodoro 32
- ✅ Introduce weapons

## 🍅 Pomodoro 33
- ✅ Should not be able to move through enemies.
- ✅ Unless they are KOd

## 🍅 Pomodoro 34
- ✅ Party attacks in LoS
- ✅ Floors en Ceilings
- ✅ Minimap shows all enemies

## 🍅 Pomodoro 35
- ✅ Fix ❌ Minimap shows enemies regardless if theres LoS
- ✅ Fix ❌ Enemies start moving to play regardless of LoS

## 🍅 Pomodoro 36
- ✅ Models for walls, floors and ceiling

## 🍅 Pomodoro 37
- ✅ Walls, floors, ceiling and stairs are lit

## 🍅 Pomodoro 38
- ✅ Light skeleton correctly
- ✅ Add ambient lighting

## 🍅 Pomodoro 39
- ✅ Add 'drop shadow' to enemies
- ✅ And anti-aliasing

## 🍅 Pomodoro 40
- 🚧 Abilities that can be combined
    - ✅ Different properties -> combination of properties
    - ✅ Different effects -> all trigger
    - ✅ Same property -> added together
    - ⚠️ Refactor for object calestenics
