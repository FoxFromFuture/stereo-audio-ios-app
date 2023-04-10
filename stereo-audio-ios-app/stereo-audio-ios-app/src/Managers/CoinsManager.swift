//
//  CoinsManager.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 24.03.2023.
//

import UIKit

class CoinsManager {
    
    // MARK: - Fields
    static let shared = CoinsManager()
    
    // MARK: - LifeCycle
    private init() { }
    
    func getCurrentAmount() -> Int {
        return UserDefaults.standard.integer(forKey: "coins")
    }
    
    func addCoins(amount: Int) {
        let curCoinsAmount = UserDefaults.standard.integer(forKey: "coins")
        UserDefaults.standard.set(curCoinsAmount + amount, forKey: "coins")
    }
    
    func takeCoins(amount: Int) {
        let curCoinsAmount = UserDefaults.standard.integer(forKey: "coins")
        UserDefaults.standard.set(curCoinsAmount - amount, forKey: "coins")
    }
}
