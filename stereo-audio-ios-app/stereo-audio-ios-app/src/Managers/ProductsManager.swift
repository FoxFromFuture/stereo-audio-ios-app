//
//  ProductManager.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 24.03.2023.
//

import UIKit

class ProductsManager {
    
    // MARK: - Fields
    static let shared = ProductsManager()
    
    // MARK: - LifeCycle
    private init() { }
    
    func buyProduct(product: String) -> Bool {
        let curCoinsAmount = CoinsManager.shared.getCurrentAmount()
        if curCoinsAmount >= 1000 {
            CoinsManager.shared.takeCoins(amount: 1000)
            self.addProductToAvailableList(product: product)
            return true
        } else {
            return false
        }
    }
    
    func setProduct(product: String) {
        if Product.user.productsList.contains(product) {
            UserDefaults.standard.set(product, forKey: "user")
        } else {
            UserDefaults.standard.set(product, forKey: "enemy")
        }
    }
    
    func getImageName(product: String) -> String {
        if Product.user.productsList.contains(product) {
            if product == "user" {
                return "person.circle.fill"
            } else {
                return "figure.stand"
            }
        } else {
            if product == "alien" {
                return "alien-img"
            } else {
                return "balloon-img"
            }
        }
    }
    
    func isUsed(product: String) -> Bool {
        if Product.user.productsList.contains(product) {
            if product == UserDefaults.standard.string(forKey: "user") {
                return true
            } else {
                return false
            }
        } else {
            if product == UserDefaults.standard.string(forKey: "enemy") {
                return true
            } else {
                return false
            }
        }
    }
    
    func isAvailable(product: String) -> Bool {
        if UserDefaults.standard.stringArray(forKey: "ownProducts")!.contains(product) {
            return true
        } else {
            return false
        }
    }
    
    private func addProductToAvailableList(product: String) {
        var curAvailableProductsList = UserDefaults.standard.stringArray(forKey: "ownProducts")
        curAvailableProductsList?.append(product)
        UserDefaults.standard.set(curAvailableProductsList, forKey: "ownProducts")
    }
}
