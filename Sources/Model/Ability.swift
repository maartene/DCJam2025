public protocol Ability {
    var key: String { get }
    var properties: [String: Any] { get }
    func execute(in world: World)
    var effect: (World, [String: Any]) -> Void { get }
}

extension Ability { 
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

func combine(_ abilities: (any Ability)...) -> CombinedAbility {
    CombinedAbility(abilities: abilities)
}

struct DummyAbility: Ability {
    let key = ""
    let properties: [String : Any] = [:]
}

public struct DamageEnemyAbility: Ability {
    public let key = "a"
    public private(set) var properties: [String : Any] = [:]
    public let effect = damageEnemyEffect
    
    public init(origin: Coordinate, heading: CompassDirection) {
        properties["origin"] = origin
        properties["heading"] = heading
        properties["aoeRange"] = 0
        properties["range"] = 1
    }
    
    public func execute(in world: World) {
        effect(world, properties)
    }
}

struct AddAoEAbility: Ability {
    public let key = "x"
    let properties: [String : Any] = ["aoeRange": 1]
}

struct CombinedAbility: Ability {
    static func *(lhs: CombinedAbility, rhs: any Ability) -> CombinedAbility {
        CombinedAbility(abilities: [lhs, rhs])
    }

    let key: String
    let properties: [String: Any]
    let effects: [(World, [String: Any]) -> Void]
    
    init(abilities: [any Ability]) {
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
        
        self.key = abilities.map {
            $0.key
        }.joined()
    }
    
    func execute(in world: World, properties: [String: Any]? = nil) {
        let properties = properties ?? self.properties
        
        for effect in effects {
            effect(world, properties)
        }
    }
}

struct HealPartyMember: Ability {
    let key = "h"
    let properties: [String : Any] = [:]
    let position: SinglePartyPosition
    
    func execute(in world: World) {
        world.partyMembers[position].heal(3)
    }
}

struct AddRangeAbility: Ability {
    let key = "x"
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
