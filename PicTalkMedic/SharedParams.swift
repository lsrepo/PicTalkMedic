//
//  SharedParams.swift
//  PicTalkMedic
//
//  Created by Pak on 10/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import Foundation


class SharedParams {
    
    var selectedLang = Language.swedish
    
    //0.35 is too slow
    var utteranceRate:Float = 0.4

}

struct Constants {
    static let textSeperator = "   /   "
}

struct Configs {
    static let touchVisualizerIsOn = false
}
