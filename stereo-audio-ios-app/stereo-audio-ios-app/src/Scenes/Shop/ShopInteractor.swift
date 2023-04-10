//
//  ShopInteractor.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 12.03.2023.
//

import UIKit

protocol ShopBusinessLogic {
    typealias Model = ShopModel
    func loadStart(_ request: Model.Start.Request)
    func loadMainMenuScene(_ request: Model.MainMenu.Request)
    func loadUserProductsList(_ request: Model.UserProducts.Request)
    func loadEnemyProductsList(_ request: Model.EnemyProducts.Request)
    func loadNextProduct(_ request: Model.NextProduct.Request)
    func loadNewProductStatus(_ request: Model.NewProductStatus.Request)
}

final class ShopInteractor {
    // MARK: - Fields
    private let presenter: ShopPresentationLogic
    
    // MARK: - LifeCycle
    init(presenter: ShopPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension ShopInteractor: ShopBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        let curLanguage = LanguageManager.shared.getCurrentLanguage()
        presenter.presentStart(Model.Start.Response(lng: curLanguage))
    }
    
    func loadMainMenuScene(_ request: Model.MainMenu.Request) {
        presenter.presentMainMenuScene(Model.MainMenu.Response())
    }
    
    func loadUserProductsList(_ request: Model.UserProducts.Request) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        var isFirstUsed = false
        if ProductsManager.shared.isUsed(product: Product.user.productsList[0]) {
            isFirstUsed = true
        } else {
            isFirstUsed = false
        }
        presenter.presentUserProductsList(Model.UserProducts.Response(isFirstUsed: isFirstUsed))
    }
    
    func loadEnemyProductsList(_ request: Model.EnemyProducts.Request) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        var isFirstUsed = false
        if ProductsManager.shared.isUsed(product: Product.enemy.productsList[0]) {
            isFirstUsed = true
        } else {
            isFirstUsed = false
        }
        presenter.presentEnemyProductsList(Model.EnemyProducts.Response(isFirstUsed: isFirstUsed))
    }
    
    func loadNextProduct(_ request: Model.NextProduct.Request) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        var curViewedProductIndex = request.curViewedProductIndex
        var arrowButtonSide = "right"
        var productName = ""
        var productImage = UIImage()
        var isProductBoundaryInList = false
        var status = "buy"
        if request.arrowButtonSide == "right" {
            curViewedProductIndex += 1
        } else {
            curViewedProductIndex -= 1
            arrowButtonSide = "left"
            if curViewedProductIndex == 0 {
                isProductBoundaryInList = true
            }
        }
        if request.isUserButtonPressed {
            productName = Product.user.productsList[curViewedProductIndex]
            productImage = UIImage(systemName: ProductsManager.shared.getImageName(product: Product.user.productsList[curViewedProductIndex]), withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 62, weight: .regular)))!
            
            if ProductsManager.shared.isUsed(product: Product.user.productsList[curViewedProductIndex]) {
                status = "used"
            } else if ProductsManager.shared.isAvailable(product: Product.user.productsList[curViewedProductIndex]) {
                status = "set"
            }
            if curViewedProductIndex + 1 == Product.user.productsList.count {
                isProductBoundaryInList = true
            }
        } else {
            productName = Product.enemy.productsList[curViewedProductIndex]
            productImage = UIImage(named: ProductsManager.shared.getImageName(product: Product.enemy.productsList[curViewedProductIndex]))!
            if ProductsManager.shared.isUsed(product: Product.enemy.productsList[curViewedProductIndex]) {
                status = "used"
            } else if ProductsManager.shared.isAvailable(product: Product.enemy.productsList[curViewedProductIndex]) {
                status = "set"
            }
            if curViewedProductIndex + 1 == Product.enemy.productsList.count {
                isProductBoundaryInList = true
            }
        }
        presenter.presentNextProduct(Model.NextProduct.Response(arrowButtonSide: arrowButtonSide, productName: productName, productImage: productImage, isProductBoundaryInList: isProductBoundaryInList, status: status, curViewedProductIndex: curViewedProductIndex))
    }
    
    func loadNewProductStatus(_ request: Model.NewProductStatus.Request) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        var newStatus = "buy"
        if request.isUserButtonPressed {
            let curProduct = Product.user.productsList[request.curViewedProductIndex]
            if ProductsManager.shared.isAvailable(product: curProduct) {
                ProductsManager.shared.setProduct(product: curProduct)
                newStatus = "used"
            } else {
                if ProductsManager.shared.buyProduct(product: curProduct) {
                    newStatus = "set"
                }
            }
        } else {
            let curProduct = Product.enemy.productsList[request.curViewedProductIndex]
            if ProductsManager.shared.isAvailable(product: curProduct) {
                ProductsManager.shared.setProduct(product: curProduct)
                newStatus = "used"
            } else {
                if ProductsManager.shared.buyProduct(product: curProduct) {
                    newStatus = "set"
                }
            }
        }
        presenter.presentNewProducyStatus(Model.NewProductStatus.Response(newStatus: newStatus))
    }
}
