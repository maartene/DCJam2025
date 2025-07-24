import Foundation
import Testing
import Model

@Suite("The party should be able to perform attacks") struct PartyAttackTests {
    @Test("and damage an enemy when it is close enough") func partyAttacksEnemies() throws {
        let world = makeWorld(from: [
            ".s"
        ])

        let enemy = try #require(world.enemiesOnCurrentFloor.first)

        let hpOfEnemyBeforeAttack = enemy.hp

        world.executeCommand(.executeHandAbility(user: .frontLeft, hand: .primary), at: Date())

        #expect(enemy.hp < hpOfEnemyBeforeAttack)
    }

    @Test("and should not damage an enemy when it is outside of range") func partyAttacksEnemiesOutOfRangeDoesNoDamage() throws {
        let world = makeWorld(from: [
            "..s"
        ])

        let enemy = try #require(world.enemiesOnCurrentFloor.first)

        let hpOfEnemyBeforeAttack = enemy.hp

        world.executeCommand(.executeHandAbility(user: .frontRight, hand: .primary), at: Date())

        #expect(enemy.hp == hpOfEnemyBeforeAttack)
    }

    @Test("should be able to make a melee attack from the front row") func meleeAttackFromFrontRowDamagesEnemy() throws {
        let world = makeWorld(from: [
            ".s"
        ])

        let enemy = try #require(world.enemiesOnCurrentFloor.first)

        let hpOfEnemyBeforeAttack = enemy.hp

        world.executeCommand(.executeHandAbility(user: .frontLeft, hand: .primary), at: Date())

        #expect(enemy.hp < hpOfEnemyBeforeAttack)
    }

    @Test("should not be able to make a melee attack from the back row") func meleeAttackFromBackRowDoesNotDamageEnemy() throws {
        let world = makeWorld(from: [
            ".s"
        ])
        world.partyMembers[.backLeft].setAttackStrategyToMelee()
        
        let enemy = try #require(world.enemiesOnCurrentFloor.first)

        let hpOfEnemyBeforeAttack = enemy.hp

        world.executeCommand(.executeHandAbility(user: .backLeft, hand: .primary), at: Date())

        #expect(enemy.hp == hpOfEnemyBeforeAttack)
    }

    @Test("should not be able to make a melee attack when in cooldown") func meleeAttackWhenInCooldownDoesNotDamageEnemy() throws {
        let world = makeWorld(from: [
            ".s"
        ])

        let enemy = try #require(world.enemiesOnCurrentFloor.first)
        world.executeCommand(.executeHandAbility(user: .frontLeft, hand: .primary), at: Date())

        let hpOfEnemyBeforeAttack = enemy.hp

        world.executeCommand(.executeHandAbility(user: .frontLeft, hand: .primary), at: Date())

        #expect(enemy.hp == hpOfEnemyBeforeAttack)
    }
    
    @Test("should not be able to make a melee attack when KOd") func meleeAttackWhenKoDoesNotDamageEnemy() throws {
        let world = makeWorld(from: [
            ".s"
        ])

        let enemy = try #require(world.enemiesOnCurrentFloor.first)
        world.partyMembers[.frontRight].takeDamage(Int.max)

        let hpOfEnemyBeforeAttack = enemy.hp
        
        world.executeCommand(.executeHandAbility(user: .frontRight, hand: .primary), at: Date())

        #expect(enemy.hp == hpOfEnemyBeforeAttack)
    }

    @Test("should be able to attack with secondary hand after primary hand attacked") func secondaryHandCanAlsoAttack() throws {
        let world = makeWorld(from: [
            ".s"
        ])

        let enemy = try #require(world.enemiesOnCurrentFloor.first)
        world.executeCommand(.executeHandAbility(user: .frontLeft, hand: .primary), at: Date())
        
        let hpOfEnemyBeforeAttack = enemy.hp
        
        world.executeCommand(.executeHandAbility(user: .frontLeft, hand: .secondary), at: Date())

        #expect(enemy.hp < hpOfEnemyBeforeAttack)
    }
}

@Suite("Ranged party members should") struct RangedPartyMembersShould {
    @Test("hit enemies further away") func hitEnemiesFurtherAway() throws {
        let world = makeWorld(from: [
            "...s"
        ])
        
        let enemy = try #require(world.enemiesOnCurrentFloor.first)
        let hpOfEnemyBeforeAttack = enemy.hp
        
        world.executeCommand(.executeHandAbility(user: .backLeft, hand: .primary), at: Date())
        
        #expect(enemy.hp < hpOfEnemyBeforeAttack)
    }
}

@Suite("Magic party members should") struct MagicPartyMembersShould {
    @Test("hit enemies further away") func hitMultipleEnemiesAtOnce() throws {
        let world = makeWorld(from: [
            ".ss"
        ])
        
        let hpOfEnemies = world.enemiesOnCurrentFloor.reduce(into: [:]) { result, enemy in
            result[enemy] = enemy.hp
        }
        
        world.executeCommand(.executeHandAbility(user: .backRight, hand: .primary), at: Date())
        
        for enemy in world.enemiesOnCurrentFloor {
            #expect(enemy.hp < hpOfEnemies[enemy, default: 0])
        }
    }
}
