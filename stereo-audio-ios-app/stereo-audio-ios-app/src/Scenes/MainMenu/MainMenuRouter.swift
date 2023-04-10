//
//  MainMenuRouter.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 12.03.2023.
//

import UIKit

protocol MainMenuRoutingLogic {
    func routeToStartGameScene()
    func routeToShopScene()
    func routeToTutorialScene()
}

final class MainMenuRouter {
    // MARK: - Fields
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension MainMenuRouter: MainMenuRoutingLogic {
    func routeToStartGameScene() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        view?.navigationController?.pushViewController(StartGameAssembly.build(), animated: false)
    }

    func routeToShopScene() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        view?.navigationController?.pushViewController(ShopAssembly.build(), animated: false)
    }
    
    func routeToTutorialScene() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        view?.navigationController?.present(TutorialAssembly.build(), animated: true)
    }
}
