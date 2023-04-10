//
//  ShopPresenter.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 12.03.2023.
//

import UIKit

protocol ShopPresentationLogic {
    typealias Model = ShopModel
    func presentStart(_ response: Model.Start.Response)
    func presentMainMenuScene(_ response: Model.MainMenu.Response)
    func presentUserProductsList(_ response: Model.UserProducts.Response)
    func presentEnemyProductsList(_ request: Model.EnemyProducts.Response)
    func presentNextProduct(_ response: Model.NextProduct.Response)
    func presentNewProducyStatus(_ response: Model.NewProductStatus.Response)
}

final class ShopPresenter {
    // MARK: - Fields
    weak var view: ShopDisplayLogic?
}

// MARK: - PresentationLogic
extension ShopPresenter: ShopPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel(lng: response.lng))
    }
    
    func presentMainMenuScene(_ response: Model.MainMenu.Response) {
        view?.displayMainMenuScene(Model.MainMenu.ViewModel())
    }
    
    func presentUserProductsList(_ response: Model.UserProducts.Response) {
        view?.displayUserProductsList(Model.UserProducts.ViewModel(isFirstUsed: response.isFirstUsed))
    }
    
    func presentEnemyProductsList(_ response: Model.EnemyProducts.Response) {
        view?.displayEnemyProductsList(Model.EnemyProducts.ViewModel(isFirstUsed: response.isFirstUsed))
    }
    
    func presentNextProduct(_ response: Model.NextProduct.Response) {
        view?.displayNextProduct(Model.NextProduct.ViewModel(arrowButtonSide: response.arrowButtonSide, productName: response.productName, productImage: response.productImage, isProductBoundaryInList: response.isProductBoundaryInList, status: response.status, curViewedProductIndex: response.curViewedProductIndex))
    }
    
    func presentNewProducyStatus(_ response: Model.NewProductStatus.Response) {
        view?.displayNewProductStatus(Model.NewProductStatus.ViewModel(newStatus: response.newStatus))
    }
}
