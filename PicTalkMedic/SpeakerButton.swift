//
//  SpeakerButton.swift
//  PicTalkMedic
//
//  Created by Pak on 2016-09-26.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit

@IBDesignable
class SpeakerButton: UIButton {

    @IBInspectable var borderRadius: CGFloat = 3
    @IBInspectable var borderWidth: CGFloat = 3
    @IBInspectable var borderColor: CGColor = Style.primaryColor.cgColor
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // draw the layout
        
        self.layer.borderWidth = self.borderWidth
        self.layer.cornerRadius = self.borderRadius
        self.layer.borderColor = self.borderColor
        self.titleLabel?.numberOfLines = 2
    }
}
