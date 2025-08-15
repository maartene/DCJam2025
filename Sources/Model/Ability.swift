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

struct AoEAbility: Ability {

}

struct CombinedAbility: Ability {
    let aoeRange = 1
}