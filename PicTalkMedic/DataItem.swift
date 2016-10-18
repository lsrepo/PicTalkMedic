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
    var swedish : String?
    var arabic : String?
    var arabicFemale :String?
    var picName: String?
    var parent: String?
    var child: String?
    
    var pic:UIImage
  
    init(swedish:String?, arabic:String?,arabicFemale:String?,picName:String?,parent:String?,child:String?) {
        self.swedish = swedish
        self.arabic = arabic
        self.arabicFemale = arabicFemale
        self.picName = picName
        self.parent = parent
        self.child = child
        self.pic = UIImage(named: "fallback")!
      
        
    }
    
    func getPic(selectedGender:Gender)-> UIImage{
        
        //A. find the name first
        
        //find the corresponding gender
        if let pic = UIImage(named: self.picName! + selectedGender.rawValue){
            self.pic = pic
        }else if let pic = UIImage(named: self.picName! + Gender.neutral.rawValue){
            // fin a neutral pic
            self.pic = pic
        }else if let pic = UIImage(named: self.picName!){
            // fin a neutral pic
            self.pic = pic
        }else if let pic = UIImage(named: self.picName! +  Gender.male.rawValue){
            // last resort: use the male one
            self.pic = pic
        }
        
        //B. return a pic
        return self.pic
    }
    
    //TO-DO: get arabic of correct gender
}

func ==(lhs: DataItem, rhs: DataItem) -> Bool {
    return lhs.swedish == rhs.swedish && lhs.picName == rhs.picName
}

//class ArabicWord{
//    var hasMaleForm:Bool
//    var hasFemaleForm:Bool
//    var hasNeutralForm:Bool
//}
