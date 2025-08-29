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
    @Suite("adding abilities should") struct AddingAbilities {
        let partyMember = PartyMember.makeMage(name: "Example member", position: .backRight)
        @Test("increase the number of abilities by one") func addAbilityTest() {
            let originalAbilityCount = partyMember.abilities.count

            let newAbility = DummyAbility()
            partyMember.addAbility(newAbility)

            #expect(partyMember.abilities.count == originalAbilityCount + 1)
        }

        @Test("add the specific ability") func addSpecificAbilityTest() {
            let newAbility = DummyAbility()
            let originalAbilityCount = partyMember.abilities.count { $0.key == newAbility.key }

            partyMember.addAbility(newAbility)

            #expect(partyMember.abilities.count { $0.key == newAbility.key } == originalAbilityCount + 1)
        }
    }

    @Suite("deleting abilities should") struct DeletingAbilities {
        let partyMember = PartyMember.makeMage(name: "Example member", position: .backRight)
        @Test("not remove any ability that doesnt exist") func dontRemoveAbilityThatDoesNotExist() {
            let originalAbilityCount = partyMember.abilities.count

            partyMember.deleteAbility(DummyAbility())

            #expect(partyMember.abilities.count == originalAbilityCount)
        }

        @Test("delete the specified ability") func deleteSpecifiedAbility() throws {
            let ability = try #require(partyMember.abilities.first)
            let originalAbilityCount = partyMember.abilities.count { $0.key == ability.key }

            partyMember.deleteAbility(ability)

            #expect(partyMember.abilities.count { $0.key == ability.key } == originalAbilityCount - 1)
        }
    }
    
}