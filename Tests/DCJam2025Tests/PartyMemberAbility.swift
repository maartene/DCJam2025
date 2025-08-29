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
    
    @Suite("changing an ability should") struct ChangeAbilityTests {
        @Suite("when adding a component to an ability") struct AddComponentToAbility {
            let partyMember = PartyMember.makeMage(name: "Example member", position: .backRight)
            @Test("add a component to an existing ability") func addComponentToAbility() throws {
                let originalAbility = try #require(partyMember.abilities.first)

                let component = AddRangeAbility()
                partyMember.addComponentToAbility(component: component, to: originalAbility)

                let changedAbility = try #require(partyMember.abilities.first)

                #expect(changedAbility.key == "\(originalAbility.key)\(component.key)")
            }

            @Test("not add a component to an existing ability when existing ability cant be found") func abilityNotFound() throws {
                let component = AddRangeAbility()
                let originalAbilityKeys = partyMember.abilities.map { $0.key }
                
                partyMember.addComponentToAbility(component: component, to: DummyAbility())

                let changedAbilityKeys = partyMember.abilities.map { $0.key }

                #expect(changedAbilityKeys == originalAbilityKeys)
            }
        }

        @Suite("when removing a component from an ability") struct RemoveComponentFromAbility { 
            let partyMember = PartyMember.makeMeleePartyMember(name: "Example member", position: .frontRight)
            @Test("it should be removed from the key") func removeComponentFromAbilityTest() throws {
                
                let originalAbility = try #require(partyMember.abilities.first)
                let originalAbilityKeys = originalAbility.key.map { String($0) }
                try #require(originalAbilityKeys.count > 0)

                partyMember.removeComponentFromAbility(componentKey: originalAbilityKeys.first!, from: originalAbility)

                let changedAbility = try #require(partyMember.abilities.first)
                let changedAbilityKeys = changedAbility.key.map { String($0) }

                #expect(changedAbilityKeys.count == originalAbilityKeys.count - 1)
            }
        }
        
    }
}