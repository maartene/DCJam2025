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
    
    //var frontLeft: PartyMember { members[0] }
    //var frontRight: PartyMember { members[1] }
    var backLeft: PartyMember { members[2] }
    var backRight: PartyMember { members[3] }
    
    var hasAlivePartyMember: Bool {
        members.filter { $0.isAlive }.isEmpty == false
    }
    
    var frontRow: [PartyMember] {
        [getMember(at: .frontLeft), getMember(at: .frontRight)]
    }

    var backRow: [PartyMember] {
        [backLeft, backRight]
    }

    var all: [PartyMember] {
        members
    }
}

enum SinglePartyPosition {
    case frontLeft
    case frontRight
    case backLeft
    case backRight
}
