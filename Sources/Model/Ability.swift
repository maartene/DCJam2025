public protocol Ability {
    var key: String { get }
    var properties: [String: Any] { get }
    func execute(by partyMember: PartyMember, in world: World)
    var effect: EffectSignature { get }
}

public typealias EffectSignature = (PartyMember, World, [String: Any]) -> Void

extension Ability {
    subscript(key: String) -> Any? {
        properties[key]
    }
    
    func execute(by partyMember: PartyMember, in world: World) {
        effect(partyMember, world, properties)
    }
    
    var effect: EffectSignature {
        return { partyMember, _,_ in print("\(partyMember.name) executed ability \(self)") }
    }
}

func combine(_ abilities: (any Ability)...) -> CombinedAbility {
    CombinedAbility(abilities: abilities)
}

// MARK: Concrete abilities
struct DummyAbility: Ability {
    let key = ""
    let properties: [String : Any] = [:]
}

public struct DamageEnemyAbility: Ability {
    public let key = "a"
    
    public let properties: [String : Any]
    public let effect = damageEnemyEffect
    
    init() {
        properties = [
            "aoeRange": 0,
            "range": 1
        ]
    }
    
    public func execute(by partyMember: PartyMember, in world: World) {
        effect(partyMember, world, properties)
    }
}

struct AddAoEAbility: Ability {
    public let key = "x"
    let properties: [String : Any] = ["aoeRange": 1]
}

struct CombinedAbility: Ability {
    let key: String
    let properties: [String: Any]
    let effects: [EffectSignature]
    
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
    
    func execute(by partyMember: PartyMember, in world: World) {
        //let properties = properties ?? self.properties
        
        for effect in effects {
            effect(partyMember, world, properties)
        }
    }
}

struct HealPartyMember: Ability {
    let key = "h"
    let properties: [String : Any] = [:]
    public let effect = healPartyMemberEffect
    
    func execute(by partyMember: PartyMember, in world: World) {
        effect(partyMember, world, properties)
    }
}

struct AddRangeAbility: Ability {
    let key = "x"
    let properties: [String : Any] = ["range": 2]
}

struct AddPotencyAbility: Ability {
    let properties: [String : Any] = ["potency": 2]
    let key = "s"
}

// MARK: Effects
func damageEnemyEffect(caster: PartyMember, in world: World, properties: [String: Any]) {
    let baseDamage = 3
    let origin = world.partyPosition
    let heading = world.partyHeading
    let aoeRange = properties["aoeRange"] as! Int
    let range = properties["range"] as! Int
    let potency = properties["potency", default: 0] as! Int
    
    guard let impactPosition = findPlaceOfImpact(origin: origin, heading: heading, range: range) else {
        return
    }
    
    world.enemiesOnCurrentFloor
        .filter {
            $0.position.manhattanDistanceTo(impactPosition) <= aoeRange
        }
        .forEach {
            $0.takeDamage(baseDamage + potency)
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

func healPartyMemberEffect(caster: PartyMember, in world: World, properties: [String: Any]) {
    let baseHealAmount = 3
    let aoeRange = properties["aoeRange", default: 0] as! Int
    let ownerPosition = caster.positionInParty
    let potency = properties["potency", default: 0] as! Int
    
    let healAmount = baseHealAmount + potency
    
    if aoeRange > 0 {
        world.partyMembers.getMembers(grouping: .all)
            .forEach { $0.heal(healAmount) }
    } else {
        world.partyMembers[ownerPosition].heal(healAmount)
    }
}

