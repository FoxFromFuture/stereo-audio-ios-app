//
//  ShopAssembly.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 24.03.2023.
//

import UIKit

enum ShopAssembly {
    static func build() -> UIViewController {
        let router: ShopRouter = ShopRouter()
        let presenter: ShopPresenter = ShopPresenter()
        let interactor: ShopInteractor = ShopInteractor(presenter: presenter)
        let viewController: ShopViewController = ShopViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
