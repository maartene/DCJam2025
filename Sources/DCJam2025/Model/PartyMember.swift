//
//  PartyMember.swift
//  DCJam2025
//
//  Created by Maarten Engels on 24/04/2025.
//

final class PartyMember {
    var isAlive = true
    
    func takeDamage(_ amount: Int) {
        isAlive = false
    }
}
