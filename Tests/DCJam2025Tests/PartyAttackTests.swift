import Foundation
import Testing
import Model

@Suite("The party should be able to perform attacks") struct PartyAttackTests {
    @Suite("Given a melee attack") struct MeleeAttacks {
        @Suite("when enemy is close enough") struct PartyIsCloseEnough {
            let world = makeWorld(from: [
                """
                .
                s
                """
            ])

            @Test("can attack an enemy") func canAttackEnemy() {
                #expect(world.partyMembers[.frontLeft].canExecuteAbility(for: .primary, at: Date()))
            }

            @Test("should damage an enemy") func enemyDamagesParty() throws {
                let enemy = try #require(world.enemiesOnCurrentFloor.first)

                let hpOfEnemyBeforeAttack = enemy.currentHP

                world.executeCommand(.executeHandAbility(user: .frontLeft, hand: .primary), at: Date())

                #expect(enemy.currentHP < hpOfEnemyBeforeAttack)
            }

            @Test("should be able to make a melee attack from the front row") func meleeAttackFromFrontRowDamagesEnemy() throws {
                let enemy = try #require(world.enemiesOnCurrentFloor.first)

                let hpOfEnemyBeforeAttack = enemy.currentHP

                world.executeCommand(.executeHandAbility(user: .frontLeft, hand: .primary), at: Date())

                #expect(enemy.currentHP < hpOfEnemyBeforeAttack)
            }

            @Test("should not be able to make a melee attack when in cooldown") func meleeAttackWhenInCooldownDoesNotDamageEnemy() throws {
                let enemy = try #require(world.enemiesOnCurrentFloor.first)
                world.executeCommand(.executeHandAbility(user: .frontLeft, hand: .primary), at: Date())

                let hpOfEnemyBeforeAttack = enemy.currentHP

                world.executeCommand(.executeHandAbility(user: .frontLeft, hand: .primary), at: Date())

                #expect(world.partyMembers[.frontLeft].canExecuteAbility(for: .primary, at: Date()) == false)
                #expect(enemy.currentHP == hpOfEnemyBeforeAttack)
            }

            @Test("should not be able to make a melee attack when KOd") func meleeAttackWhenKoDoesNotDamageEnemy() throws {
                let enemy = try #require(world.enemiesOnCurrentFloor.first)
                world.partyMembers[.frontRight].takeDamage(Int.max)

                let hpOfEnemyBeforeAttack = enemy.currentHP

                #expect(world.partyMembers[.frontRight].canExecuteAbility(for: .primary, at: Date()) == false)

                world.executeCommand(.executeHandAbility(user: .frontRight, hand: .primary), at: Date())

                #expect(enemy.currentHP == hpOfEnemyBeforeAttack)
            }

            @Test("should be able to attack with secondary hand after primary hand attacked") func secondaryHandCanAlsoAttack() throws {
                let enemy = try #require(world.enemiesOnCurrentFloor.first)
                world.executeCommand(.executeHandAbility(user: .frontLeft, hand: .primary), at: Date())

                let hpOfEnemyBeforeAttack = enemy.currentHP

                world.executeCommand(.executeHandAbility(user: .frontLeft, hand: .secondary), at: Date())

                #expect(enemy.currentHP < hpOfEnemyBeforeAttack)
            }
        }

        @Test("and should not damage an enemy when it is outside of range") func partyAttacksEnemiesOutOfRangeDoesNoDamage() throws {
            let world = makeWorld(from: [
                """
                .
                .
                s
                """
            ])

            let enemy = try #require(world.enemiesOnCurrentFloor.first)

            let hpOfEnemyBeforeAttack = enemy.currentHP

            world.executeCommand(.executeHandAbility(user: .frontRight, hand: .primary), at: Date())

            #expect(enemy.currentHP == hpOfEnemyBeforeAttack)
        }

        @Test("should not be able to make a melee attack from the back row") func meleeAttackFromBackRowDoesNotDamageEnemy() throws {
            let world = makeWorld(from: [
                """
                .
                s
                """
            ])

            world.partyMembers[.backLeft].equipWeapon(.bareHands, in: .primary)

            let enemy = try #require(world.enemiesOnCurrentFloor.first)

            let hpOfEnemyBeforeAttack = enemy.currentHP

            world.executeCommand(.executeHandAbility(user: .backLeft, hand: .primary), at: Date())

            #expect(enemy.currentHP == hpOfEnemyBeforeAttack)
        }
    }

    @Suite("Given a ranged attack") struct RangedAttacks {
        @Test("should use a two handed weapon") func shouldUseATwoHandedWeapon() {
            let partyMember = PartyMember.makeRanger(name: "Foo")

            #expect(partyMember.canExecuteAbility(for: .secondary, at: Date()) == false)
        }

        @Test("should hit enemies further away") func hitEnemiesFurtherAway() throws {
            let world = makeWorld(from: [
                """
                .
                .
                s
                """
            ])

            let enemy = try #require(world.enemiesOnCurrentFloor.first)
            let hpOfEnemyBeforeAttack = enemy.currentHP

            world.executeCommand(.executeHandAbility(user: .backLeft, hand: .primary), at: Date())

            #expect(enemy.currentHP < hpOfEnemyBeforeAttack)
        }

        @Test("should not hit enemies that are not in front of it") func hitEnemiesInFrontOfIt() throws {
            let world = makeWorld(from: [
                "..s"
            ])

            let enemy = try #require(world.enemiesOnCurrentFloor.first)
            let hpOfEnemyBeforeAttack = enemy.currentHP

            world.executeCommand(.executeHandAbility(user: .backLeft, hand: .primary), at: Date())

            #expect(enemy.currentHP == hpOfEnemyBeforeAttack)
        }
    }

    @Suite("Given a magic attack") struct MagicPartyMembersShould {
        @Test("should hit multiple enemies") func hitMultipleEnemiesAtOnce() throws {
            let world = makeWorld(from: [
                """
                .
                s
                s
                """
            ])

            let hpOfEnemies = world.enemiesOnCurrentFloor.reduce(into: [:]) { result, enemy in
                result[enemy] = enemy.currentHP
            }

            world.executeCommand(.executeHandAbility(user: .backRight, hand: .primary), at: Date())

            for enemy in world.enemiesOnCurrentFloor {
                #expect(enemy.currentHP < hpOfEnemies[enemy, default: 0])
            }
        }
    }
}
