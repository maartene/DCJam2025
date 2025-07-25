import Testing
import Model

@Suite("Equipment should") struct EquipmentTests {
    @Suite("given a partymember that has an archetypical class") struct ArchetypesTests {
        @Test("a ranger should be handling a bow") func rangerShouldBeHandlingABow() {
            let partyMember = PartyMember.makeRangedPartyMember(name: "Foo")

            #expect(partyMember.primaryHand.weaponType == .bow)
        }
    }
}