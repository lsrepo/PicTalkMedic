//
//  UtterManager.swift
//  PicTalkMedic
//
//  Created by Pak on 2016-09-26.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import Foundation
import AVFoundation
/// a singletone that handles utterence

class UtterManager{
    
  static let sharedInstance = UtterManager()
    //synthesizer
    let synthesizer = AVSpeechSynthesizer()
    
    func utter(sharedParams:SharedParams, selectedItem:DataItem){
  
        //prepare text
        var text = ""
        
        // default
        var utterLang = Language.arabic.rawValue
        
        switch sharedParams.selectedLang{
        case .arabic:
            text = selectedItem.arabic!
            utterLang = Language.arabic.rawValue
            
        case .swedish:
            text = selectedItem.swedish!
            utterLang = Language.swedish.rawValue
        default:
            break
        }
        
        
        //action
        let utter = AVSpeechUtterance(string: text)
        utter.voice = AVSpeechSynthesisVoice(language: utterLang)
        
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utter)
    }
    
    func configureUtterance(text:String){
        
    }
    
}
