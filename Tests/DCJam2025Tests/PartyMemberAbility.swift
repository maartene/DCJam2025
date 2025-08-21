import Foundation
import Testing
import Model



@Suite("The party should be able to perform abilities") struct PartyPerfomsAbilitiesTests {
    @Suite("given a generic ability") class GenericAbility {
        let world = World(floors: [Floor()])
        private(set) var count = 0
        private(set) var ability: any Ability = MockAbility(properties: [:])
        
        init() {
            ability = SpyAbility {
                self.count += 1
            }
        }
        
        @Test("should be able to be executed") func executeAbility() {
            world.executeCommand(.executeAbility(user: .frontRight, ability: ability), at: Date())
            
            #expect(count == 1)
            
        }
        
        @Test("should not be executed when ability is in cooldown") func abilityInCooldown() {
            world.executeCommand(.executeAbility(user: .frontRight, ability: ability), at: Date())
            world.executeCommand(.executeAbility(user: .frontRight, ability: ability), at: Date())
            
            #expect(count == 1)
        }
        
        @Test("should not be executed when party member is KOd") func abilityWhenMemberIsKo() {
            world.partyMembers[.frontLeft].takeDamage(Int.max)
            world.executeCommand(.executeAbility(user: .frontLeft, ability: ability), at: Date())
            
            #expect(count == 0)
        }
    }
}
