import Foundation
import Testing
@testable import Model



@Suite("The party should be able to perform abilities") struct PartyPerfomsAbilitiesTests {
    @Suite("given a generic ability") class GenericAbility {
        let world = World(floors: [Floor()])
        private(set) var count = 0
        private(set) var ability: any Ability = MockAbility(properties: [:])
        
        init() {
            ability = SpyAbility {
                self.count += 1
            }
            
            for partyMember in world.partyMembers.getMembers(grouping: .all) {
                partyMember.abilities = [ability]
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
        
        @Test("should not be executed if ability is not in the party members ability list") func abilityNotInAbilityList() {
            #expect(world.partyMembers[.backLeft].canExecuteAbility(MockAbility(properties: [:]), at: Date()) == false)
        }
    }
}

@Suite("The party should be able to change abilities") struct ChangeAbilitiesTests {
    @Suite("adding abilities") struct AddingAbilities {
        let world = World(floors: [Floor()])
        @Test("increase the number of abilities by one") func addAbilityTest() {
            let partyMember = world.partyMembers[.backRight]
            let originalAbilityCount = partyMember.abilities.count

            let newAbility = DummyAbility()
            partyMember.addAbility(newAbility)

            #expect(partyMember.abilities.count == originalAbilityCount + 1)
        }
    }

    @Suite("deleting abilities") struct DeletingAbilities {
        let world = World(floors: [Floor()])
        @Test("should lower the amount of abilities by one") func deleteAbilityTest() throws {
            let partyMember = world.partyMembers[.backRight]
            let originalAbilityCount = partyMember.abilities.count

            let ability = try #require(partyMember.abilities.first)
            partyMember.deleteAbility(ability)

            #expect(partyMember.abilities.count == originalAbilityCount - 1)
        }

        @Test("should not remove any ability that doesnt exist") func dontRemoveAbilityThatDoesNotExist() {
            let partyMember = world.partyMembers[.backRight]
            let originalAbilityCount = partyMember.abilities.count

            partyMember.deleteAbility(DummyAbility())

            #expect(partyMember.abilities.count == originalAbilityCount)
        }
    }
    
}