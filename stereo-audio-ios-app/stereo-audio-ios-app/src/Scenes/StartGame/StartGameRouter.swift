//
//  StartGameRouter.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 12.03.2023.
//

import UIKit

protocol StartGameRoutingLogic {
    func routeToMainMenuScene()
    func routeToOnScreenGameScene()
    func routeToARGameScene()
}

final class StartGameRouter {
    // MARK: - Fields
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension StartGameRouter: StartGameRoutingLogic {
    func routeToMainMenuScene() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        view?.navigationController?.pushViewController(MainMenuAssembly.build(), animated: false)
    }
    
    func routeToOnScreenGameScene() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        view?.navigationController?.pushViewController(OnScreenGameAssembly.build(), animated: false)
    }
    
    func routeToARGameScene() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        view?.navigationController?.pushViewController(ARGameAssembly.build(), animated: false)
    }
}
