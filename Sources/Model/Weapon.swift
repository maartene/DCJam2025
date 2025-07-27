//
//  Weapon.swift
//  DCJam2025
//
//  Created by Maarten Engels on 27/07/2025.
//

public struct Weapon: Sendable {
    let name: String
    let attackStrategy: any AttackMobStrategy
    let twoHanded: Bool
    
    public static let bareHands = Weapon(name: "Bare hands", attackStrategy: MeleeAttackMobStrategy(), twoHanded: false)
    
    public static let bow = Weapon(name: "Bow", attackStrategy: RangedAttackMobStrategy(), twoHanded: true)
    
    public static let staff = Weapon(name: "Simple Staff", attackStrategy: MagicAttackMobStrategy(), twoHanded: true)
}
