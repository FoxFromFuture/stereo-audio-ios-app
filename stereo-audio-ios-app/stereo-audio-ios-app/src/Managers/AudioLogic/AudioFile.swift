//
//  AudioFile.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 15.03.2023.
//

import UIKit
import AVFoundation

struct AudioFile {
    var name: String
    var file: File
    
    enum File: String {
        case mp3
        case wav

        var type: AVFileType {
            switch self {
            case .mp3:
                return AVFileType.mp3
            case .wav:
                return AVFileType.wav
            }
        }
    }
    
    static var alien: AudioFile {
        return AudioFile(name: "alien", file: .mp3)
    }
    static var balloon: AudioFile {
        return AudioFile(name: "balloon", file: .mp3)
    }
}
