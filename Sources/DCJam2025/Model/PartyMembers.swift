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
    
    var frontLeft: PartyMember { members[0] }
    var frontRight: PartyMember { members[1] }
    var backLeft: PartyMember { members[2] }
    var backRight: PartyMember { members[3] }
    
    var hasAlivePartyMember: Bool {
        members.filter { $0.isAlive }.isEmpty == false
    }
}
