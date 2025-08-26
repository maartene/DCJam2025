import Testing
@testable import Model

struct SpyAbility: Ability {
    let key: String = "spy"
    let properties: [String : Any] = [:]
    let effect: (World, [String : Any]) -> Void
    
    init(action: @escaping () -> Void) {
        self.effect = { _, _ in
            action()
        }
    }
}

struct MockAbility: Ability {
    let key: String
    let properties: [String: Any]
    
    init(properties: [String: Any], key: String = "") {
        self.properties = properties
        self.key = key
    }
}

@Suite("All abilities should") struct AbilityTests {    
    @Test("when they are executed, have an effect") func affectTheWorld() {
        let world = World(floors: [Floor()])
        var count = 0
        let ability = SpyAbility() {
            count += 1
        }
        
        ability.execute(in: world)
        
        #expect(count == 1)
    }
    
    @Suite("be able to be combined") struct combineAbilities {
        @Test("into a new ability that has properties combined") func combineProperties() throws{
            let ability1 = MockAbility(properties: ["property1": 42])
            let ability2 = MockAbility(properties: ["property2": 11])
            let combinedAbility = combine(ability1, ability2)
            
            let property1 = try #require(combinedAbility["property1"] as? Int)
            let property2 = try #require(combinedAbility["property2"] as? Int)
            
            #expect(property1 == 42)
            #expect(property2 == 11)
        }
        
        @Test("into an ability that has multiple effects") func multipleEffects() {
            var count1 = 0
            var count2 = 0
            let ability1 = SpyAbility() {
                count1 += 1
            }
            let ability2 = SpyAbility() {
                count2 += 1
            }
            let combinedAbility = combine(ability1, ability2)
            
            combinedAbility.execute(in: World(floors: [Floor()]))
            
            #expect(count1 == 1)
            #expect(count2 == 1)
        }
        
        @Test("into an ability where similar properties are added together") func addTogetherSimilarProperties() throws {
            let ability1 = MockAbility(properties: ["property": 1])
            let ability2 = MockAbility(properties: ["property": 2])
            let combinedAbility = combine(ability1, ability2)
            
            let property = try #require(combinedAbility["property"] as? Int)
            
            #expect(property == 3)
        }
        
        @Test("again and again") func repeatedCombination() throws {
            let ability1 = MockAbility(properties: ["property1": 1, "property3": 5])
            let ability2 = MockAbility(properties: ["property2": 2])
            let ability3 = MockAbility(properties: ["property3": 3, "property1": 8])
            let combinedAbility = combine(ability1, ability2, ability3)
            
            let property1 = try #require(combinedAbility["property1"] as? Int)
            let property2 = try #require(combinedAbility["property2"] as? Int)
            let property3 = try #require(combinedAbility["property3"] as? Int)
            
            #expect(property1 == 9)
            #expect(property2 == 2)
            #expect(property3 == 8)
        }
        
        @Test("and have a key that is a combination of the combined ability keys") func combinedKeys() throws {
            let ability1 = MockAbility(properties: [:], key: "a")
            let ability2 = MockAbility(properties: [:], key: "b")
            let combinedAbility = combine(ability1, ability2)
            
            #expect(combinedAbility.key == "ab")
        }
    }
    
}

@Suite("Concrete abilities should") struct ConcreteAbilityTests {
    @Suite("for healing abilities") struct singleAbilities {
        let world = World(floors: [Floor()])
        @Test("be able to heal a party member") func heal() {
            let ability = HealPartyMember(position: .frontLeft)
            world.partyMembers[.frontLeft].takeDamage(3)
            let hpBefore = world.partyMembers[.frontLeft].currentHP
            
            ability.execute(in: world)
            
            let hpAfter = world.partyMembers[.frontLeft].currentHP
            
            #expect(hpAfter > hpBefore)
        }
        
        @Test("not heal more than the maximum HP") func notHealOverMaximumHP() {
            let ability = HealPartyMember(position: .frontLeft)
            let hpBefore = world.partyMembers[.frontLeft].currentHP
            
            ability.execute(in: world)
            
            let hpAfter = world.partyMembers[.frontLeft].currentHP
            
            #expect(hpAfter == hpBefore)
        }
    }
    
    @Suite("For offensive abilities") struct OffensiveAbilities {
        let world = makeWorld(from: [
            """
            ppp
            pSp
            ppp
            """
        ])
        
        @Test("deal damage to a target") func dealDamageToATarget() throws {
            let ability = DamageEnemyAbility(origin: world.partyPosition, heading: world.partyHeading)
            let target = try #require( world.enemiesOnCurrentFloor.first {
                $0.position == Coordinate(x: 1, y: 2)
            })
            let hpBeforeAbility = target.currentHP
            
            ability.execute(in: world)
            
            #expect(target.currentHP < hpBeforeAbility)
        }
        
        @Test("deal damage to only a single target") func dealDamageToASingleTarget() throws {
            let ability = DamageEnemyAbility(origin: world.partyPosition, heading: world.partyHeading)
            
            ability.execute(in: world)
            
            let hpsAfterAbility = world.enemiesOnCurrentFloor
                .map { $0.currentHP }
                .reduce(into: [:]) { partialResult, hp in
                    partialResult[hp, default: 0] += 1
                }
            
            #expect(hpsAfterAbility.filter { $0.value == 1 }.count == 1)
        }
        
        @Test("deal damage in AoE") func dealDamageInAoE() throws {
            let damageEnemyAbility = DamageEnemyAbility(
                origin: world.partyPosition,
                heading: world.partyHeading)
            let addAoEAbility = AddAoEAbility()
            let ability = combine(damageEnemyAbility,  addAoEAbility)
            
            let enemyCoordinates = [
                Coordinate(x: 0, y: 2),
                Coordinate(x: 1, y: 2),
                Coordinate(x: 2, y: 2),
            ]
            
            let enemies = enemyCoordinates.map { coordinate in
                world.enemiesOnCurrentFloor.first { $0.position == coordinate }!
            }
            
            let hpBeforeAbility = enemies.map(\.currentHP)
            
            ability.execute(in: world)
            
            for i in 0 ..< enemies.count {
                #expect(enemies[i].currentHP < hpBeforeAbility[i])
            }
        }
        
        @Test("deal damage in a range") func dealDamageInRange() throws {
            let world = makeWorld(from: [
                """
                ...
                ...
                p..
                """
            ])
            
            let damageEnemyAbility = DamageEnemyAbility(
                origin: world.partyPosition,
                heading: world.partyHeading)
            let addRangeAbility = AddRangeAbility()
            let ability = combine(damageEnemyAbility, addRangeAbility)
            
            let enemy = try #require(world.enemiesOnCurrentFloor.first(where: { $0.position == Coordinate(x: 0, y: 2) } ))
                                     
            let hpBeforeAbility = enemy.currentHP
            
            ability.execute(in: world)
            
            #expect(enemy.currentHP < hpBeforeAbility)
        }
    }
    
}
