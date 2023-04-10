//
//  EndGameRouter.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 13.03.2023.
//

import UIKit

protocol EndGameRoutingLogic {
    func routeToMainMenuScene()
    func routeToPreviousGameScene()
}

final class EndGameRouter {
    // MARK: - Fields
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension EndGameRouter: EndGameRoutingLogic {
    func routeToMainMenuScene() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        view?.navigationController?.pushViewController(MainMenuAssembly.build(), animated: false)
    }
    
    func routeToPreviousGameScene() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        view?.navigationController?.pushViewController(StartGameAssembly.build(), animated: false)
    }
}
