//
//  Helper.swift
//  PicTalkMedic
//
//  Created by Pak on 02/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import Foundation
import UIKit


class DataItem :Equatable {
    var swedish : String = ""
    var arabic : String = ""
    var picName: String = ""
    var parent: String = ""
    var contain: String?
    
    var pic:UIImage
  
    init(swedish:String, arabic:String,picName:String,parent:String,contain:String?) {
        self.swedish = swedish
        self.arabic = arabic
        self.picName = picName
        self.parent = parent
        self.contain = contain
        
        if let pic = UIImage(named: self.picName){
            self.pic = pic
        }else{
            self.pic = UIImage(named: "fallback")!
        }
        
    }
    
    
}

func ==(lhs: DataItem, rhs: DataItem) -> Bool {
    return lhs.swedish == rhs.swedish && lhs.picName == rhs.picName
}