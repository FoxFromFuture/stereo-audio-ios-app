//
//  MainMenuModels.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 28.02.2023.
//

import UIKit

enum MainMenuModel {
    enum Start {
        struct Request { }
        struct Response {
            let lng: String
            let otherLng: String
        }
        struct ViewModel {
            let lng: String
            let otherLng: String
        }
        struct Info { }
    }
    
    enum StartGame {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum Shop {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum Language {
        struct Request {
            let lng: String
        }
        struct Response {
            let lng: String
        }
        struct ViewModel {
            let lng: String
        }
        struct Info { }
    }
    
    enum Tutorial {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
}
