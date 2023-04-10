//
//  ShopRouter.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 12.03.2023.
//

import UIKit

protocol ShopRoutingLogic {
    func routeToMainMenuViewController()
}

final class ShopRouter {
    // MARK: - Fields
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension ShopRouter: ShopRoutingLogic {
    func routeToMainMenuViewController() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        view?.navigationController?.pushViewController(MainMenuAssembly.build(), animated: false)
    }
}
