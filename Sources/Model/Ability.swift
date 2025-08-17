protocol Ability {
    var properties: [String: Any] { get }
    func canBeExecuted(in world: World) -> Bool
    func execute(in world: World, properties: [String: Any]?)
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
}

struct DummyAbility: Ability {
    let properties: [String : Any] = [:]

    func canBeExecuted(in world: World) -> Bool {
        true
    }
    
    func execute(in world: World, properties: [String : Any]?) {
        
    }
}

struct DamageEnemyAbility: Ability {
    private(set) var properties: [String : Any] = [:]
    
    init(origin: Coordinate, heading: CompassDirection) {
        properties["origin"] = origin
        properties["heading"] = heading
        properties["aoeRange"] = 0
    }
    
    func execute(in world: World, properties: [String: Any]? = nil) {
        let properties = properties ?? self.properties
        
        let origin = properties["origin"] as! Coordinate
        let heading = properties["heading"] as! CompassDirection
        let aoeRange = properties["aoeRange"] as! Int
        
        let target = origin + heading.forward
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

struct AddAoEAbility: Ability {
    func execute(in world: World, properties: [String : Any]?) {
        
    }
    
    let properties: [String : Any] = ["aoeRange": 1]
}

struct CombinedAbility: Ability {
    let abilities: [any Ability]
    let properties: [String: Any]
    let effects: [(World, [String: Any]?) -> Void]
    
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
        
        self.effects = abilities.map { $0.execute }
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
    
    func execute(in world: World, properties: [String: Any]? = nil) {
        world.partyMembers[position].heal(3)
    }
}
