//
//  ARGameRouter.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 13.03.2023.
//

import UIKit

protocol ARGameRoutingLogic {
    func routeToEndGameScene()
}

final class ARGameRouter {
    // MARK: - Fields
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension ARGameRouter: ARGameRoutingLogic {
    func routeToEndGameScene() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        view?.navigationController?.pushViewController(EndGameAssembly.build(), animated: false)
    }
}
