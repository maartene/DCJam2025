import Testing
@testable import Model

struct SpyAbility: Ability {
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

    @Suite("for single abilities") struct singleAbilities {
        let world = World(floors: [Floor()])
        @Test("be able to heal a party member") func heal() {
            let ability = HealPartyMember(position: .frontLeft)
            world.partyMembers[.frontLeft].takeDamage(3)
            let hpBefore = world.partyMembers[.frontLeft].currentHP
            
            ability.execute(in: world)
            
            let hpAfter = world.partyMembers[.frontLeft].currentHP
            
            #expect(hpAfter > hpBefore)
        }
    }
    
    @Suite("be able to be combined") struct combineAbilities {
        let world = makeWorld(from: [
        """
        ppp
        pSp
        ppp
        """
        ])
        
        
        
        @Test("and add an AoE effect to a damage ability") func addAoE() {
            let ability1 = DamageEnemyAbility()
            let ability2 = AddAoEAbility()
            let combinedAbility = ability1 * ability2
            let hpOfEnemiesBefore = sumOfHpOfDamageableEntities(world.enemiesOnCurrentFloor)
            
            combinedAbility.execute(in: world)
            
            let hpOfEnemiesAfter = sumOfHpOfDamageableEntities(world.enemiesOnCurrentFloor)
            
            #expect(hpOfEnemiesAfter < hpOfEnemiesBefore)
        }
        
//        @Test("into an ability that has multiple effects") func multipleEffects() {
//            let ability1 = DamageEnemyAbility()
//            let ability2 = HealPartyMember(position: .frontLeft)
//            let combinedAbility = ability1 * ability2
//            let hpOfEnemiesBefore = sumOfHpOfDamageableEntities(world.enemiesOnCurrentFloor)
//            world.partyMembers[.frontLeft].takeDamage(5)
//            let hpOfPartyMemberBefore = world.partyMembers[.frontLeft].currentHP
//            
//            combinedAbility.execute(in: world)
//            
//            let hpOfEnemiesAfter = sumOfHpOfDamageableEntities(world.enemiesOnCurrentFloor)
//            let hpOfPartyMembeAfter = world.partyMembers[.frontLeft].currentHP
//            
//            #expect(hpOfEnemiesAfter < hpOfEnemiesBefore)
//            #expect(hpOfPartyMembeAfter > hpOfPartyMemberBefore)
//            
//        }
    }
}


func sumOfHpOfDamageableEntities<T: Damageable>(_ entities: any Collection<T>) -> Int {
    entities
        .map { $0.currentHP }
        .reduce(0, +)
}
