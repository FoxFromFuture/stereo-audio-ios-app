//
//  SCNVector3+operations.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 24.03.2023.
//

import UIKit
import SceneKit

extension SCNVector3 {
    static func ~= (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        if abs(lhs.x - rhs.x) < 0.1 && abs(lhs.y - rhs.y) < 0.1 && abs(lhs.z - rhs.z) < 0.1 {
            return true
        } else {
            return false
        }
    }
    
    static func - (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }
}
