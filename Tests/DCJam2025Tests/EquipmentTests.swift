import Testing
@testable import Model

@Suite("Equipment should") struct EquipmentTests {
    @Suite("given a newly created party member") struct NewPartyMember {
        @Test("should have two bare hands") func newPartyMemberHasBareHands() {
            let partyMember = PartyMember(name: "Test")
            #expect(partyMember.primaryHand.name == Weapon.bareHands.name)
            #expect(partyMember.secondaryHand.name == Weapon.bareHands.name)
        }
    }
}
