# TECHDEBT

## ⚠️ TODO
- Missing tests to validate correct behaviour when two abilities have the same key (fixed in code)
- Structure tests in suites and subsuites
- Rotating towards party is based on trial and error: rotate, see if facing party. otherwise repeat. this could be based on dot product

## 🚧 DOING


## ✅ DONE
- no test coverage for conversion of coordinate spaces, while this might be valuable. Maybe property based testing?
- a lot of the minimap code could be tested, in particular the conversion of units and determining of correct tile names
- missing test for color multiplication in Conversions.swift
- should not be able to rotate when goal is reached
- minX, minY, maxX and maxY are constants, so can be generated only once
- missing tests in Floor
- `enemies` in `World` should not just be a coordinate, and also wrapped in its own data type
- Extract conditional in update
- message chain in `LostConditionTests` because `World` exposes array with partymembers
- enemies should be part of floor definition -> requires update to `makeWorld(from:)`
- enemies are bound to floor
- principal obsession in `partyMemberIndex`
- array with partymembers should be wrapped in its own data type
- there is duplication in `World` where multiple functions do the same check: see if player already won. Abstraction needed to conform to DRY
- Convenience initiazer is not needed and is a risk if it is not updated in sync with the regular initiazer.
- Feature envy in World.update on Enemy
- Magic numbers for range in Enemy.swift
    - [X] Range
    - [X] Damage
- DRY in MeleeEnemy and RangedEnemy
- [X] Strategy pattern for Enemies
- [X] DRY: move as much from strategies into default implementations as possible
- Movement tests in `EnemyMovementTests` use hard coded paths, these should be generated using a path finding algorithm like Dijkstra or BFS
- Is a KeyPath the right way of describing the position of a party member?
- remove the @testable from the import statement in the tests
    - [X] Remove from `EnemyTests.swift`
        - [X] make `makeWorld` public
            - [X] make `World` public
        - [X] make `update` public
        - [X] make World initializer public
            - [X] make CompassDirection public
            - [X] make Coordinate initializer public
                - [ ] make toVector3 public
            - [X] make Floor public
    - [X] ImportWorldTests
    - [X] LostConditionTests
    - [X] MappingTests
        - [X] make visitedTilesOnCurrentFloor public
    - [X] MovementTests
    - [X] PartyAttackTests
    - [X] VizualizationTests
        - [X] Make target public
        - [X] Make light public
        - [X] Make colors public
            - [X] make `*` operator public
        - [X] getSpriteAndPositionForTileAtPosition
        - [X] getSpriteAndPositionForPartyAtPosition
    - [X] WinConditionTests
- the UI will require more helper functions to draw the right buttons
- `PartyMember.setAttackStrategyToMelee` is there only for testing purposes
- Determining if party is in line of sight of enemy uses a naive raycast approach. this could be easier more elegant.
- Shader should only be set once, not for every single model every time its drawn
- Somehow the enemy does not seem lit
- Connaisence of algorithm in ability
- Duplication of logic between Enemy and World (Party)
    - Is it possible to re-use attack strategy?
    - Similarity between health of enemy and party members
- Object calestanics for Ability
- Feature envy from AbilityGUI on PartyMember
    - [X] Adding and removing abilities is fixed
    - [X] Adding/removing components needs to be done
- Missing tests to validate correct behaviour when two abilities have the same key (fixed in code)
    - [X] When removing components
    - [X] When adding components