# TECHDEBT

## ⚠️ TODO
- Is a KeyPath the right way of describing the position of a party member?
- Determining if party is in line of sight of enemy uses a naive raycast approach. this could be easier.

## 🚧 DOING
- [ ] Strategy pattern for Enemies
    - [ ] Make `Enemy` a final class
        - [ ] Remove `MeleeEnemy` class
            - [ ] `makeMeleeEnemy` should create an `Enemy` instance
                - [ ] Inject `MeleeAttackStrategy` into `Enemy`
                    - [X] Create `MeleeAttackStrategy`
                    - [ ] Remove `range` from `Enemy`
                        - [X] move `range` into `MeleeAttackStrategy`
                        - [X] move `partyIsInRange` to `MeleeAttackStrategy`
            - [X] use `makeMeleeEnemy` in tests
        - [ ] Remove `RangedEnemy` class
            - [ ] `makeRangedEnemy` should create an `Enemy` instance
                - [ ] Inject `RangedAttackStrategy` into `Enemy`
                    - [X] Create `RangedAttackStrategy`
                    - [ ] An `Enemy` needs to accept all types of AttackStrategies
                        - [ ] Introduce `AttackStrategy` protocol

## ✅ DONE
- no test coverage for conversion of coordinate spaces, while this might be valuable. Maybe property based testing?
- a lot of the minimap code could be tested, in particular the conversion of units and determining of correct tile names
- missing test for color multiplication in Conversions.swift
- should not be able to rotate when goal is reached
- minX, minY, maxX and maxY are constants, so can be generated only once
- missing tests in Floor
- `enemies` in `World` should not just be a coordinate, and also wrapped in its own data type
    - [X] Enemy needs to conform to `Hashable`
        - [X] Update needs to work on enemy positions
        - [X] `spawnEnemy` should create a new Enemy
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
