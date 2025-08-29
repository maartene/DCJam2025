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
            let partyMember = PartyMember.makeMeleePartyMember(name: "Example member", position: .frontLeft)
            @Test("add a component to an existing ability") func addComponentToAbility() throws {
                try #require(partyMember.abilities.count > 1)
                let originalAbility = partyMember.abilities[1]

                let component = AddRangeAbility()
                partyMember.addComponentToAbility(component: component, to: 1)

                let changedAbility = partyMember.abilities[1]

                #expect(changedAbility.key == "\(originalAbility.key)\(component.key)")
            }

            @Test("not add a component to an existing ability when existing ability cant be found") func abilityNotFound() throws {
                let component = AddRangeAbility()
                let originalAbilityKeys = partyMember.abilities.map { $0.key }
                
                partyMember.addComponentToAbility(component: component, to: 5)

                let changedAbilityKeys = partyMember.abilities.map { $0.key }

                #expect(changedAbilityKeys == originalAbilityKeys)
            }
        }

        @Suite("when removing a component from an ability") struct RemoveComponentFromAbility { 
            let partyMember = PartyMember.makeMeleePartyMember(name: "Example member", position: .frontRight)
            @Test("it should be removed from the key") func removeComponentFromAbilityTest() throws {
                
                try #require(partyMember.abilities.count > 1) 

                let originalAbility0 = partyMember.abilities[0]
                let originalAbility1 = partyMember.abilities[1]
                let originalAbility0Keys = originalAbility0.key.map { String($0) }
                let originalAbility1Keys = originalAbility1.key.map { String($0) }

                partyMember.removeComponentFromAbility(componentKey: originalAbility1Keys.first!, from: 1)

                let changedAbility0 = partyMember.abilities[0]
                let changedAbility1 = partyMember.abilities[1]
                let changedAbility0Keys = changedAbility0.key.map { String($0) }
                let changedAbility1Keys = changedAbility1.key.map { String($0) }

                #expect(changedAbility0Keys.count == originalAbility0Keys.count)
                #expect(changedAbility1Keys.count == originalAbility1Keys.count - 1)
            }
        }
        
    }
}