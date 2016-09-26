//
//  Style.swift
//  PicTalkMedic
//
//  Created by Pak on 04/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import Foundation
import CoreImage
import UIKit


struct Style{
    static let borderRadius:CGFloat = 5
    static let borderWidth:CGFloat  = 2
    
    static let wordCellBackgroundColor = UIColor.white
    static let contextCellBackgroundColor = UIColor.white
    
    static let primaryColor = UIColor.rgb(red: 245, green: 166, blue: 35, alpha: 1)
}


extension UIColor {
    /// It takes rgb and returns a UIColor.
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}
