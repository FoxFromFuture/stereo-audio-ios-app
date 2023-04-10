//
//  AudioSource.swift
//  stereo-audio-ios-app
//
//  Created by FoxFromFuture on 15.03.2023.
//

import UIKit
import AVFoundation

class AudioSource {
    let audio: AudioFile
    var startPoint: CGPoint

    var player: AVAudioPlayer?

    var timer: Timer?
    
    var distance: CGFloat {
        return sqrt(self.audioVector.dx * self.audioVector.dx + self.audioVector.dy * self.audioVector.dy)
    }

    var volume: CGFloat {
        return 1 / (distance / 1000) / 100
    }
    
    var yaw: CGFloat = 0 {
        didSet {
            self.updateAudioPan()
        }
    }
    
    var userVector: CGVector {
        let vector = CGVector(dx: 1, dy: 0)
        let rotatedVector = CGVector(dx: vector.dx * cos(self.yaw) - vector.dy * sin(self.yaw), dy: vector.dx * sin(self.yaw) + vector.dy * cos(self.yaw))
        return rotatedVector
    }
    
    var audioVector: CGVector {
        return CGVector(dx: self.startPoint.x, dy: self.startPoint.y)
    }

    init(audio: AudioFile, startPoint: CGPoint) {
        self.audio = audio
        self.startPoint = startPoint
        self.runAudio()
        self.updateVolume()
        self.updateAudioPan()
    }
    
    func updateVolume() {
        self.player?.volume = Float(self.volume)
    }

    func updateAudioPan() {
        self.player?.pan = Float(self.getAudioPan(userVector: self.userVector, audioVector: self.audioVector))
    }
    
    func updatePosition(newPoint: CGPoint) {
        self.startPoint = newPoint
        self.updateVolume()
    }

    func stopAudio() {
        self.player?.stop()
        self.timer?.invalidate()
    }

    func runAudio() {
        guard let url = Bundle.main.url(forResource: self.audio.name, withExtension: self.audio.file.rawValue) else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: self.audio.file.type.rawValue)
            self.player?.isMeteringEnabled = true

            guard let player = self.player else { return }

            player.numberOfLoops = -1
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }

        self.timer = Timer(timeInterval: 0.000001, repeats: true) { _ in
            self.player?.updateMeters()
        }
        RunLoop.current.add(self.timer!, forMode: .common)
    }
    
    private func getAudioPan(userVector: CGVector, audioVector: CGVector) -> CGFloat {
        let angle = getAngleBetweenVectors(userVector: userVector, audioVector: audioVector)
        let degAngle = angle * CGFloat(180 / Double.pi)
        
        if degAngle > -90 || degAngle < 90 {
            if degAngle.sign == .plus {
                return 1 - (degAngle / 90)
            } else {
                self.player?.volume = Float(self.volume - 0.1)
                return 1 - (-degAngle / 90)
            }
        } else {
            if degAngle.sign == .plus {
                return -1 + ((180 - degAngle) / 90)
            } else {
                self.player?.volume = Float(self.volume - 0.1)
                return -1 + ((180 + degAngle) / 90)
            }
        }
    }
    
    private func getAngleBetweenVectors(userVector: CGVector, audioVector: CGVector) -> CGFloat {
        return atan2(audioVector.dy, audioVector.dx) - atan2(userVector.dy, userVector.dx)
    }
}
