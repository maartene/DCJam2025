import Foundation
import Testing
import Model



@Suite("The party should be able to perform abilities") struct PartyPerfomsAbilitiesTests {
    @Suite("given a generic ability") struct GenericAbility {
        @Test("should be able to be executed") func executeAbility() {
            let world = World(floors: [Floor()])
            var count = 0
            let ability = SpyAbility {
                count += 1
            }
            
            world.executeCommand(.executeAbility(user: .frontRight, ability: ability), at: Date())
            
            #expect(count == 1)
            
        }
        
        @Test("should not be executed when ability is in cooldown") func abilityInCooldown() {
            let world = World(floors: [Floor()])
            var count = 0
            let ability = SpyAbility {
                count += 1
            }
            
            world.executeCommand(.executeAbility(user: .frontRight, ability: ability), at: Date())
            world.executeCommand(.executeAbility(user: .frontRight, ability: ability), at: Date())
            
            #expect(count == 1)
        }
    }
}
