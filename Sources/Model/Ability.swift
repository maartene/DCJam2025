protocol Ability {
    func canBeExecuted(in world: World) -> Bool
    func execute(in world: World)
}

extension Ability { 
    static func *(lhs: Self, rhs: any Ability) -> CombinedAbility {
        CombinedAbility()
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
    func execute(in world: World) {
        let enemiesOnCurrentFloor = world.enemiesOnCurrentFloor
        enemiesOnCurrentFloor.forEach {
            $0.takeDamage(3)
        }
    }
}
