import Testing
@testable import Model

struct SpyAbility: Ability {
    let action: () -> ()

    func execute(in world: World) {
        action()
    }
}

@Suite("Abilities should") struct AbilityTests {
    @Test("be able to be executed in the world") func beAbleToBeExecutedInTheWorld() {
        let world = World(floors: [Floor()])
        
        let ability = DummyAbility()
        
        #expect(ability.canBeExecuted(in: world)) 
    }

    @Test("when they are executed, have an effect") func affectTheWorld() {
        let world = World(floors: [Floor()])
        var count = 0
        let ability = SpyAbility() {
            count += 1
        }
        
        ability.execute(in: world)

        #expect(count == 1)
    }

    @Suite("be able to be combined") struct combineAbilities {
        @Test("and add an AoE effect to a damage ability") func addAoE() {
            let ability1 = DamageEnemyAbility()
            let ability2 = AddAoEAbility()
            
            let world = makeWorld(from: [
            """
            ppp
            pSp
            ppp
            """
            ])
            
            let combinedAbility = ability1 * ability2
            let hpOfEnemiesBefore = world.enemiesOnCurrentFloor
                .map { $0.hp }
                .reduce(0, +)
            
            combinedAbility.execute(in: world)
            
            let hpOfEnemiesAfter = world.enemiesOnCurrentFloor
                .map { $0.hp }
                .reduce(0, +)
            
            #expect(hpOfEnemiesAfter < hpOfEnemiesBefore)
        }
    }
}
