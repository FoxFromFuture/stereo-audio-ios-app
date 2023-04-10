//
//  TutorialInteractor.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 27.03.2023.
//

import UIKit

protocol TutorialBusinessLogic {
    typealias Model = TutorialModel
    func loadStart(_ request: Model.Start.Request)
    func loadArTutorImage(_ request: Model.ARTutor.Request)
    func loadOnScreenTutorImage(_ request: Model.OnScreenTutor.Request)
    func loadSoundLicenseWebSite(_ request: Model.SoundLicense.Request)
}

final class TutorialInteractor {
    // MARK: - Fields
    private let presenter: TutorialPresentationLogic
    
    // MARK: - LifeCycle
    init(presenter: TutorialPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension TutorialInteractor: TutorialBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        let curLanguage = LanguageManager.shared.getCurrentLanguage()
        presenter.presentStart(Model.Start.Response(lng: curLanguage))
    }
    
    func loadArTutorImage(_ request: Model.ARTutor.Request) {
        presenter.presentArTutorImage(Model.ARTutor.Response())
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func loadOnScreenTutorImage(_ request: Model.OnScreenTutor.Request) {
        presenter.presentOnScreenTutorImage(Model.OnScreenTutor.Response())
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func loadSoundLicenseWebSite(_ request: Model.SoundLicense.Request) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        presenter.presentSoundLicenseWebsite(Model.SoundLicense.Response())
    }
}
