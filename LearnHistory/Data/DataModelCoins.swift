//
//  DataModelPoints.swift
//  FirstQuizTest
//
//  Created by Normand Martin on 2021-11-23.
//

import Foundation
struct Coins {
    static let goodAnswer1 = 1
    static let goodAnswer2 = 2
    static let goodAnswer3 = 3
    static let goodAnswer4 = 4
    static let goodAnswer5 = 5
    static let badAnswer1 = -1
    static let badAnswer2 = -2
    static let hint2 = -1
    static let hint1 = -1
}
struct GoodAnswer1 {
    static func add() {
        var coins = UserDefaults.standard.integer(forKey: "coins")
        coins += Coins.goodAnswer1
        UserDefaults.standard.set(coins, forKey: "coins")
    }
}
struct GoodAnswer2 {
    static func add() {
        var coins = UserDefaults.standard.integer(forKey: "coins")
        coins += Coins.goodAnswer2
        UserDefaults.standard.set(coins, forKey: "coins")
    }
}
struct GoodAnswer3 {
    static func add() {
        var coins = UserDefaults.standard.integer(forKey: "coins")
        coins += Coins.goodAnswer3
        UserDefaults.standard.set(coins, forKey: "coins")
    }
}
struct GoodAnswer4 {
    static func add() {
        var coins = UserDefaults.standard.integer(forKey: "coins")
        coins += Coins.goodAnswer4
        UserDefaults.standard.set(coins, forKey: "coins")
    }
}
struct GoodAnswer5 {
    static func add() {
        var coins = UserDefaults.standard.integer(forKey: "coins")
        coins += Coins.goodAnswer5
        UserDefaults.standard.set(coins, forKey: "coins")
    }
}
struct BadAnswer1 {
    static func substract() {
        var coins = UserDefaults.standard.integer(forKey: "coins")
        coins += Coins.badAnswer1
        UserDefaults.standard.set(coins, forKey: "coins")
        
    }
    
}
struct BadAnswer2 {
    static func substract() {
        var coins = UserDefaults.standard.integer(forKey: "coins")
        coins += Coins.badAnswer2
        UserDefaults.standard.set(coins, forKey: "coins")
    }
}
struct Hint1 {
    static func substract() {
        var coins = UserDefaults.standard.integer(forKey: "coins")
        coins += Coins.hint1
        UserDefaults.standard.set(coins, forKey: "coins")
    }
    
}
struct Hint2 {
    static func substract() {
        var coins = UserDefaults.standard.integer(forKey: "coins")
        coins += Coins.hint2
        UserDefaults.standard.set(coins, forKey: "coins")
    }
}
