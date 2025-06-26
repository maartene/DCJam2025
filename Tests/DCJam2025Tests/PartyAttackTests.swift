import Foundation 
import Testing
@testable import DCJam2025

@Suite("The party should be able to perform attacks") struct PartyAttackTests {
    @Test("and damage an enemy when it is close enough") func partyAttacksEnemies() throws {
        let world = makeWorld(from: [
            ".s"
        ])
        
        let enemy = try #require(world.enemiesOnCurrentFloor.first)
        
        let hpOfEnemyBeforeAttack = enemy.hp
        
        world.executeCommand(.attack(from: \.frontLeft))
        
        #expect(enemy.hp < hpOfEnemyBeforeAttack)
    }

    @Test("and should not damage an enemy when it is outside of range") func partyAttacksEnemiesOutOfRangeDoesNoDamage() throws {
        let world = makeWorld(from: [
            "..s"
        ])
        
        let enemy = try #require(world.enemiesOnCurrentFloor.first)
        
        let hpOfEnemyBeforeAttack = enemy.hp
        
        world.executeCommand(.attack(from: \.frontRight))
        
        #expect(enemy.hp == hpOfEnemyBeforeAttack)
    }
    
    @Test("should be able to make a melee attack from the front row") func meleeAttackFromFrontRowDamagesEnemy() throws {
        let world = makeWorld(from: [
            ".s"
        ])
        
        let enemy = try #require(world.enemiesOnCurrentFloor.first)
        
        let hpOfEnemyBeforeAttack = enemy.hp
        
        world.executeCommand(.attack(from: \.frontLeft))
        
        #expect(enemy.hp < hpOfEnemyBeforeAttack)
    }
}
