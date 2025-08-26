public protocol Ability {
    var key: String { get }
    var properties: [String: Any] { get }
    func execute(in world: World)
    var effect: (World, [String: Any]) -> Void { get }
    
    static func makeAbility(ownerPosition: SinglePartyPosition) -> Self
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

// MARK: Concrete abilities
struct DummyAbility: Ability {
    static func makeAbility(ownerPosition: SinglePartyPosition) -> DummyAbility {
        DummyAbility()
    }
    
    private init() {
        
    }
    
    let key = ""
    let properties: [String : Any] = [:]
}

public struct DamageEnemyAbility: Ability {
    public static func makeAbility(ownerPosition: SinglePartyPosition) -> DamageEnemyAbility {
        DamageEnemyAbility()
    }
    
    public let key = "a"
    
    public let properties: [String : Any]
    public let effect = damageEnemyEffect
    
    init() {
        properties = [
            "aoeRange": 0,
            "range": 1
        ]
    }
    
    public func execute(in world: World) {
        effect(world, properties)
    }
}

struct AddAoEAbility: Ability {
    static func makeAbility(ownerPosition: SinglePartyPosition) -> AddAoEAbility {
        AddAoEAbility()
    }
    
    public let key = "x"
    let properties: [String : Any] = ["aoeRange": 1]
}

struct CombinedAbility: Ability {
    static func makeAbility(ownerPosition: SinglePartyPosition) -> CombinedAbility {
        fatalError("Don't use `makeAbility` to create a CombinedAbility, use `combine(:) instead`")
    }
    
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
    static func makeAbility(ownerPosition: SinglePartyPosition) -> HealPartyMember {
        HealPartyMember(ownerPosition: ownerPosition)
    }
    
    let key = "h"
    let properties: [String : Any]
    public let effect = healPartyMemberEffect
    
    init(ownerPosition: SinglePartyPosition) {
        properties = ["ownerPosition": ownerPosition]
    }
    
    func execute(in world: World) {
        effect(world, properties)
    }
}

struct AddRangeAbility: Ability {
    static func makeAbility(ownerPosition: SinglePartyPosition) -> AddRangeAbility {
        AddRangeAbility()
    }
    
    let key = "x"
    let properties: [String : Any] = ["range": 2]
}

// MARK: Effects
func damageEnemyEffect(in world: World, properties: [String: Any]) {
    let origin = world.partyPosition
    let heading = world.partyHeading
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
            .filter {
                world.currentFloor.hasUnobstructedView(from: origin, to: $0)
            }
            .first { impactPosition in
                if world.enemiesOnCurrentFloor.first(where: { $0.position == impactPosition }) != nil {
                    return true
                }
            
                return false
            }
    }
}


func healPartyMemberEffect(in world: World, properties: [String: Any]) {
    let aoeRange = properties["aoeRange", default: 0] as! Int
    let ownerPosition = properties["ownerPosition"] as! SinglePartyPosition
    
    if aoeRange > 0 {
        world.partyMembers.getMembers(grouping: .all)
            .forEach { $0.heal(3) }
    } else {
        world.partyMembers[ownerPosition].heal(3)
    }
}

