//
//  SoundOption.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2021-05-18.
//  Copyright © 2021 Normand Martin. All rights reserved.
//

import UIKit
import AVFoundation
class SoundOption {
    static func soundOnOff() -> String{
        var soundState = String()
        if let soundStateTrans = UserDefaults.standard.string(forKey: "soundState"){
            soundState = soundStateTrans
        }
        if soundState == "speaker" {
            soundState = "speaker.slash"
        }else{
            soundState = "speaker"
        }
        UserDefaults.standard.setValue(soundState, forKey: "soundState")
        return soundState
    }
    
    
}
