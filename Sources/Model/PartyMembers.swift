//
//  PartyMembers.swift
//  DCJam2025
//
//  Created by Maarten Engels on 29/05/2025.
//

import Foundation

public struct PartyMembers {
    private let members: [PartyMember]

    init(members: [PartyMember]) {
        self.members = members
    }

    public subscript(position: SinglePartyPosition) -> PartyMember {
        getMember(at: position)
    }

    private func getMember(at position: SinglePartyPosition) -> PartyMember {
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

    public func getMembers(grouping: PartyPositionGroup) -> [PartyMember] {
        return switch grouping {
        case .frontRow:
            [getMember(at: .frontLeft), getMember(at: .frontRight)]
        case .backRow:
            [getMember(at: .backLeft), getMember(at: .backRight)]
        case .all:
            members
        }
    }

    public var hasAlivePartyMember: Bool {
        members.filter { $0.isAlive }.isEmpty == false
    }

    public func executeHandAbility(from userPosition: SinglePartyPosition, hand: PartyMember.Hand, in world: World, at time: Date) {
        let user = getMember(at: userPosition)

        let ability = user.abilityForHand(hand: hand)

        guard ability.allowedPartyPositions.toSinglePartyPositions.contains(userPosition) else {
            return
        }
        
        user.executeHandAbility(hand: hand, in: world, at: time)
    }
}

public enum SinglePartyPosition {
    case frontLeft
    case frontRight
    case backLeft
    case backRight
}

public enum PartyPositionGroup {
    case frontRow
    case backRow
    case all
    
    var toSinglePartyPositions: [SinglePartyPosition] {
        switch self {
            case .frontRow:
            return [.frontLeft, .frontRight]
        case .backRow:
            return [.backLeft, .backRight]
        case .all:
            return [.frontLeft, .frontRight, .backLeft, .backRight]
        }
    }
}
