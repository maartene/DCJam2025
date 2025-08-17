protocol Ability {
    var properties: [String: Any] { get }
    func canBeExecuted(in world: World) -> Bool
    func execute(in world: World)
}

extension Ability { 
    static func *(lhs: Self, rhs: any Ability) -> CombinedAbility {
        CombinedAbility(abilities: [lhs, rhs])
    }

    subscript(key: String) -> Any? {
        properties[key]
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
    let properties: [String : Any] = [:]

    func canBeExecuted(in world: World) -> Bool {
        true
    }
}

struct DamageEnemyAbility: Ability {
    let properties: [String : Any] = [:]
    
    func execute(in world: World) {
        let enemiesOnCurrentFloor = world.enemiesOnCurrentFloor
        enemiesOnCurrentFloor.forEach {
            $0.takeDamage(3)
        }
    }
}

struct AddAoEAbility: Ability {
    let properties: [String : Any] = [:]
}

struct CombinedAbility: Ability {
    let abilities: [any Ability]
    
    func execute(in world: World) {
        for ability in abilities {
            ability.execute(in: world)
        }
    }

    var properties: [String: Any] {
        abilities.map { $0.properties }
        .reduce(into: [:]) { partialResult, otherProperties in
            partialResult.merge(otherProperties) { existing, new in
                if let existingInt = existing as? Int, let newInt = new as? Int {
                    return existingInt + newInt
                } else {
                    return new
                }
            }
        }
    }
}

struct HealPartyMember: Ability {
    let properties: [String : Any] = [:]
    let position: SinglePartyPosition
    
    func execute(in world: World) {
        world.partyMembers[position].heal(3)
    }
}
