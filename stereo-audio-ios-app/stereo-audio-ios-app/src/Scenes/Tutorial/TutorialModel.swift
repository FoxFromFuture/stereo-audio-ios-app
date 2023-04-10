//
//  TutorialModel.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 27.03.2023.
//

import UIKit

enum TutorialModel {
    enum Start {
        struct Request { }
        struct Response {
            let lng: String
        }
        struct ViewModel {
            let lng: String
        }
        struct Info { }
    }
    
    enum ARTutor {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum OnScreenTutor {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum SoundLicense {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
}
