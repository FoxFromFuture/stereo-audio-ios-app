//
//  StartGameInteractor.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 12.03.2023.
//

import UIKit
import AVFoundation

protocol StartGameBusinessLogic {
    typealias Model = StartGameModel
    func loadStart(_ request: Model.Start.Request)
    func loadMainMenuScene(_ request: Model.MainMenu.Request)
    func loadOnScreenGameScene(_ request: Model.OnScreenGame.Request)
    func loadARGameScene(_ request: Model.ARGame.Request)
}

final class StartGameInteractor {
    // MARK: - Fields
    private let presenter: StartGamePresentationLogic
    private var curLanguage: String?
    
    // MARK: - LifeCycle
    init(presenter: StartGamePresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - Actions
    private func cameraAccessAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Error",
                                                message: "camAlert".localize(lng: self.curLanguage ?? Language.en.str),
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "cancel".localize(lng: self.curLanguage ?? Language.en.str), style: .default))
        alertController.addAction(UIAlertAction(title: "settings".localize(lng: self.curLanguage ?? Language.en.str), style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    print("Settings opened")
                })
            }
        })
        return alertController
    }
}

// MARK: - BusinessLogic
extension StartGameInteractor: StartGameBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        let curLanguage = LanguageManager.shared.getCurrentLanguage()
        self.curLanguage = curLanguage
        presenter.presentStart(Model.Start.Response(lng: curLanguage))
    }
    
    func loadMainMenuScene(_ request: Model.MainMenu.Request) {
        presenter.presentMainMenuScene(Model.MainMenu.Response())
    }
    
    func loadOnScreenGameScene(_ request: Model.OnScreenGame.Request) {
        presenter.presentOnScreenGameScene(Model.OnScreenGame.Response())
    }
    
    func loadARGameScene(_ request: Model.ARGame.Request) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            let alert = self.cameraAccessAlert()
            presenter.presentCameraAccessAlert(Model.CameraAccess.Response(alert: alert))
        case .restricted:
            print("Restricted, device owner must approve")
            let alert = self.cameraAccessAlert()
            presenter.presentCameraAccessAlert(Model.CameraAccess.Response(alert: alert))
        case .authorized:
            print("Authorized, proceed")
            presenter.presentARGameScene(Model.ARGame.Response())
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                    DispatchQueue.main.async {
                        self.presenter.presentARGameScene(Model.ARGame.Response())
                    }
                } else {
                    print("Permission denied")
                }
            }
        @unknown default:
            print("Unknown error :/")
        }
    }
}
