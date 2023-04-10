//
//  ARGameAssembly.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 24.03.2023.
//

import UIKit

enum ARGameAssembly {
    static func build() -> UIViewController {
        let router: ARGameRouter = ARGameRouter()
        let presenter: ARGamePresenter = ARGamePresenter()
        let interactor: ARGameInteractor = ARGameInteractor(presenter: presenter)
        let viewController: ARGameViewController = ARGameViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
