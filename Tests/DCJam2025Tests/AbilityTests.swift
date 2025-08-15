import Testing
@testable import Model

struct SpyAbility {
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
}