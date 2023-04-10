//
//  Product.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 24.03.2023.
//

import UIKit

enum Product {
    case user
    case enemy
    
    var productsList: [String] {
        switch self {
        case .user:
            return ["user", "human"]
        case .enemy:
            return ["alien", "balloon"]
        }
    }
    
    var current: String {
        switch self {
        case .user:
            return UserDefaults.standard.string(forKey: "user") ?? self.productsList[0]
        case .enemy:
            return UserDefaults.standard.string(forKey: "enemy") ?? self.productsList[0]
        }
    }
    
    var curProductImageName: String {
        switch self {
        case .user:
            if self.current == self.productsList[0] {
                return "person.circle.fill"
            } else {
                return "figure.stand"
            }
        case .enemy:
            if self.current == self.productsList[0] {
                return "alien-img"
            } else {
                return "balloon-img"
            }
        }
    }
    
    var curProductARObjectName: String? {
        switch self {
        case .user:
            return nil
        case .enemy:
            return "\(self.current)" + ".usdz"
        }
    }
}
