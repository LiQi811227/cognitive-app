//
//  speech.swift
//  cognitive app
//
//  Created by LiQi on 4/11/19.
//  Copyright © 2019 LiQi. All rights reserved.
//

import Foundation
import AVFoundation

func speech(_ word: String,_ source:String){
    let avSpeechSynthesizer = AVSpeechSynthesizer()
    //avSpeechSynthesizer.delegate = self

    // Session 1 --- AVSpeechUtterance: 7 Parameters of synthesized speech
    let utterance = AVSpeechUtterance(string: word)
    var languageFlg = "en-US"
    if source == "to" {languageFlg="zh-CN"}
    utterance.voice = AVSpeechSynthesisVoice(language: languageFlg)
    utterance.rate = 0.5
    utterance.pitchMultiplier = 1.0
    utterance.volume = 0.5
//    utterance.preUtteranceDelay = ...
//    utterance.postUtteranceDelay = ...

    // Session 2 --- AVSpeechSynthesizer: 4 Speech operations
    avSpeechSynthesizer.speak(utterance) // Start speech
    //avSpeechSynthesizer.stopSpeaking(at: .word) // Stop
}
