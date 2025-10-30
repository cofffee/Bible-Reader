//
//  SpeachManager.swift
//  BibleReader
//
//  Created by Kevin Remigio on 8/1/25.
//

import Foundation
import AVFoundation

class SpeechManager: NSObject {
    static let shared = SpeechManager()
    @MainActor private let synthesizer = AVSpeechSynthesizer()
    private var currentUtteranceIndex = 0
    private var stop = false
    private var pause = false
    private var pauseIndex = 0
    var queue: [String] = []
    override init() {
        super.init()
        Task {
            await MainActor.run {
                synthesizer.delegate = self
            }
        }
    }
    func speakFromBeginning() {
        stop = false
        pause = false
        speakNext()
    }
    func pauseSpeaking() {
        pause = true
        Task {
            await MainActor.run {
                synthesizer.pauseSpeaking(at: .immediate)
            }
        }
    }
    func stopSpeaking() {
        currentUtteranceIndex = 0
        stop = true
        Task {
            await MainActor.run {
                synthesizer.stopSpeaking(at: .immediate)
            }
        }
    }
    func speakNext() {
        pauseIndex = currentUtteranceIndex
        guard currentUtteranceIndex < queue.count, !stop else {
            print("Finished speaking all chunks.")
            currentUtteranceIndex = 0
            return
        }
        speak(string: queue[currentUtteranceIndex])
    }

    func speak(string: String) {
        Task {
            await MainActor.run {
                let utterance = AVSpeechUtterance(string: string)
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                utterance.pitchMultiplier = 1.0 //0.8
                
                synthesizer.speak(utterance)
                synthesizer.stopSpeaking(at: .immediate)
            }
        }
    }
}
extension SpeechManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didPause utterance: AVSpeechUtterance) {
            currentUtteranceIndex = pauseIndex
            pause = true
    }
    func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance) {
            print("did finish utterance currentUtteranceindex: \(currentUtteranceIndex)")
            currentUtteranceIndex += 1
            guard !pause else { return }
            speakNext()
    }
    func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didCancel utterance: AVSpeechUtterance) {
        print("Speech cancelled.")
    }
}
