import Foundation 
import Testing
@testable import DCJam2025

@Suite("The party should be able to perform attacks") struct PartyAttackTests {
    @Test("when they are close enough") func partyAttacksEnemies() throws {
        let world = makeWorld(from: [
            ".s"
        ])
        
        let enemy = try #require(world.enemiesOnCurrentFloor.first)
        
        let hpOfEnemyBeforeAttack = enemy.hp
        
        world.executeCommand(.attack)
        
        #expect(enemy.hp < hpOfEnemyBeforeAttack)
    }
}