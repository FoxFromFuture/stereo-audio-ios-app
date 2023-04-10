//
//  TutorialPresenter.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 27.03.2023.
//

import UIKit

protocol TutorialPresentationLogic {
    typealias Model = TutorialModel
    func presentStart(_ response: Model.Start.Response)
    func presentArTutorImage(_ response: Model.ARTutor.Response)
    func presentOnScreenTutorImage(_ response: Model.OnScreenTutor.Response)
    func presentSoundLicenseWebsite(_ response: Model.SoundLicense.Response)
}

final class TutorialPresenter {
    // MARK: - Fields
    weak var view: TutorialDisplayLogic?
}

// MARK: - PresentationLogic
extension TutorialPresenter: TutorialPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel(lng: response.lng))
    }
    
    func presentArTutorImage(_ response: Model.ARTutor.Response) {
        view?.displayArTutorImage(Model.ARTutor.ViewModel())
    }
    
    func presentOnScreenTutorImage(_ response: Model.OnScreenTutor.Response) {
        view?.displayOnScreenTutorImage(Model.OnScreenTutor.ViewModel())
    }
    
    func presentSoundLicenseWebsite(_ response: Model.SoundLicense.Response) {
        view?.displaySoundLicenseWebsite(Model.SoundLicense.ViewModel())
    }
}
