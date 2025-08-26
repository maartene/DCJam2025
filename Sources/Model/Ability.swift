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
    let key: String
    let properties: [String: Any]
    let effects: [(World, [String: Any]) -> Void]
    
    init(abilities: [any Ability]) {
        self.properties = abilities
            .map { $0.properties }
            .reduce(into: [:]) { partialResult, otherProperties in
                partialResult.merge(otherProperties) { existing, new in
                    combineProperty(existing, new)
                }
            }
        
        self.effects = abilities.map { $0.effect }
        
        self.key = abilities.map {
            $0.key
        }.joined()
        
        func combineProperty(_ existing: Any, _ new: Any) -> Any {
            if let existingInt = existing as? Int, let newInt = new as? Int {
                return existingInt + newInt
            } else {
                return new
            }
        }
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
    
    guard let impactPosition = findPlaceOfImpact(origin: origin, heading: heading, range: range) else {
        return
    }
    
    world.enemiesOnCurrentFloor
        .filter {
            $0.position.manhattanDistanceTo(impactPosition) <= aoeRange
        }
        .forEach {
            $0.takeDamage(3)
        }
    
    func findPlaceOfImpact(origin: Coordinate, heading: CompassDirection, range: Int) -> Coordinate? {
        (1 ... range)
            .map { origin + heading.forward * $0 }
            .first { impactPosition in
                if world.enemiesOnCurrentFloor.first(where: { $0.position == impactPosition }) != nil {
                    return true
                }
            
                return false
            }
    }
}
