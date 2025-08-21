//
//  Damageable.swift
//  DCJam2025
//
//  Created by Maarten Engels on 21/08/2025.
//

public protocol Damageable {
    var currentHP: Int { get }
    func takeDamage(_ amount: Int)
}
