protocol Ability {
    var properties: [String: Any] { get }
    func canBeExecuted(in world: World) -> Bool
    func execute(in world: World)
    var effect: (World, [String: Any]) -> Void { get }
}

extension Ability { 
    static func *(lhs: Self, rhs: any Ability) -> CombinedAbility {
        CombinedAbility(abilities: [lhs, rhs])
    }

    subscript(key: String) -> Any? {
        properties[key]
    }
    
    func execute(in world: World) {
        effect(world, properties)
    }
    
    var effect: ((World, [String: Any]) -> Void) {
        return { _,_ in print("Executed ability \(self)") }
    }
}

extension Ability {
    func canBeExecuted(in world: World) -> Bool {
        true
    }
}

struct DummyAbility: Ability {
    let properties: [String : Any] = [:]
}

struct DamageEnemyAbility: Ability {
    private(set) var properties: [String : Any] = [:]
    let effect = damageEnemyEffect
    
    init(origin: Coordinate, heading: CompassDirection) {
        properties["origin"] = origin
        properties["heading"] = heading
        properties["aoeRange"] = 0
        properties["range"] = 1
    }
    
    func execute(in world: World) {
        effect(world, properties)
    }
}

struct AddAoEAbility: Ability {
    let properties: [String : Any] = ["aoeRange": 1]
}

struct CombinedAbility: Ability {
    let abilities: [any Ability]
    let properties: [String: Any]
    let effects: [(World, [String: Any]) -> Void]
    
    init(abilities: [any Ability]) {
        self.abilities = abilities
        
        self.properties = abilities.map { $0.properties }
            .reduce(into: [:]) { partialResult, otherProperties in
                partialResult.merge(otherProperties) { existing, new in
                    if let existingInt = existing as? Int, let newInt = new as? Int {
                        return existingInt + newInt
                    } else {
                        return new
                    }
                }
            }
        
        self.effects = abilities.map { $0.effect }
    }
    
    func execute(in world: World, properties: [String: Any]? = nil) {
        let properties = properties ?? self.properties
        
        for effect in effects {
            effect(world, properties)
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

struct AddRangeAbility: Ability {
    let properties: [String : Any] = ["range": 2]
}

func damageEnemyEffect(in world: World, properties: [String: Any]) {
    let origin = properties["origin"] as! Coordinate
    let heading = properties["heading"] as! CompassDirection
    let aoeRange = properties["aoeRange"] as! Int
    let range = properties["range"] as! Int
    
    for currentRange in 1 ... range {
        let target = origin + heading.forward * currentRange
        let targets = world.enemiesOnCurrentFloor
            .filter {
                (target.x - aoeRange ... target.x + aoeRange).contains($0.position.x) &&
                (target.y - aoeRange ... target.y + aoeRange).contains($0.position.y)
            }
            .filter {
                $0.position.manhattanDistanceTo(target) <= aoeRange
            }
        targets.forEach { $0.takeDamage(3)}
    }
            
    
}
