protocol Ability {
    func canBeExecuted(in world: World) -> Bool
    func execute(in world: World)
}

extension Ability { 
    static func *(lhs: Self, rhs: any Ability) -> CombinedAbility {
        CombinedAbility(abilities: [lhs, rhs])
    }
}

extension Ability {
    func canBeExecuted(in world: World) -> Bool {
        true
    }

    func execute(in world: World) {
        print("Executed ability")
    }
}

struct DummyAbility: Ability {
    func canBeExecuted(in world: World) -> Bool {
        true
    }
}

struct DamageEnemyAbility: Ability {
    
}

struct AddAoEAbility: Ability {

}

struct CombinedAbility: Ability {
    let abilities: [any Ability]
    
    func execute(in world: World) {
        let enemiesOnCurrentFloor = world.enemiesOnCurrentFloor
        enemiesOnCurrentFloor.forEach {
            $0.takeDamage(3)
        }
        
        for ability in abilities {
            ability.execute(in: world)
        }
    }
}

struct HealPartyMember: Ability {
    let position: SinglePartyPosition
    
    func execute(in world: World) {
        world.partyMembers[position].heal(3)
    }
}
