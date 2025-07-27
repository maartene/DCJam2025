import Testing
@testable import Model

@Suite("Equipment should") struct EquipmentTests {
    @Suite("given a newly created party member") struct NewPartyMember {
        @Test("should have two bare hands") func newPartyMemberHasBareHands() {
            let partyMember = PartyMember(name: "Test")
            #expect(partyMember.primaryHand.name == Weapon.bareHands.name)
            #expect(partyMember.secondaryHand.name == Weapon.bareHands.name)
        }
        
        @Test("when equipping a two handed weapon, should have two occupied hands") func equipTwoHandedWeapon() {
            let partyMember = PartyMember(name: "Test")
            
            partyMember.equipWeapon(.bow, in: .primary)
            
            #expect(partyMember.primaryHand.name == Weapon.bow.name)
            #expect(partyMember.secondaryHand.name == Weapon.bow.name)
        }
    }
    
    @Suite("given a party member with a two handed weapon equiped") struct PartyMemberWithTwoHandedWeapon {
        let partyMember = {
            let newPartyMember = PartyMember(name: "Example")
            newPartyMember.equipWeapon(.bow, in: .primary)
            return newPartyMember
        }()
        
        @Test("when a single handed weapon is equipped, the other hand should become bare hands") func equipsSingleHandedWeaponOtherHandBare() {
            partyMember.equipWeapon(.dagger, in: .primary)
            
            #expect(partyMember.primaryHand.name == Weapon.dagger.name)
            #expect(partyMember.secondaryHand.name == Weapon.bareHands.name)
        }
    }
}
