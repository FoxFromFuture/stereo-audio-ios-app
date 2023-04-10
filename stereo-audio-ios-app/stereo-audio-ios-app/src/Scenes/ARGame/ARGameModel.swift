//
//  ARGameModels.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 13.03.2023.
//

import UIKit
import SceneKit
import ARKit

enum ARGameModel {
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
    
    enum Game {
        struct Request {
            let arSceneView: ARSCNView
        }
        struct Response {
            let action: ((CGPoint) -> Void)
        }
        struct ViewModel {
            let action: ((CGPoint) -> Void)
        }
        struct Info { }
    }
    
    enum NewScore {
        struct Request { }
        struct Response {
            let score: Int
        }
        struct ViewModel {
            let score: Int
        }
        struct Info { }
    }
    
    enum EndGame {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
}
