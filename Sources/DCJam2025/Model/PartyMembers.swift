//
//  PartyMembers.swift
//  DCJam2025
//
//  Created by Maarten Engels on 29/05/2025.
//

struct PartyMembers {
    private let members: [PartyMember]
    
    init(members: [PartyMember]) {
        self.members = members
    }
    
    func getMember(at position: SinglePartyPosition) -> PartyMember {
        return switch position {
        case .frontLeft:
            members[0]
        case .frontRight:
            members[1]
        case .backLeft:
            members[2]
        case .backRight:
            members[3]
        }
    }
    
    func getMembers(grouping: PartyPositionGroup) -> [PartyMember] {
        return switch grouping {
        case .frontRow:
            [getMember(at: .frontLeft), getMember(at: .frontRight)]
        case .backRow:
            [getMember(at: .backLeft), getMember(at: .backRight)]
        case .all:
            members
        }
    }
    
    var hasAlivePartyMember: Bool {
        members.filter { $0.isAlive }.isEmpty == false
    }
    
    func attack(from attackPosition: SinglePartyPosition, in world: World) {
        if attackPosition == .frontLeft || attackPosition == .frontRight {
            let attacker = getMember(at: attackPosition)
            attacker.attack(potentialTargets: world.enemiesOnCurrentFloor, partyPosition: world.partyPosition)
        }

    }
}

enum SinglePartyPosition {
    case frontLeft
    case frontRight
    case backLeft
    case backRight
}

enum PartyPositionGroup {
    case frontRow
    case backRow
    case all
}
