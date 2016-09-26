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

    @IBInspectable var borderRadius: CGFloat = Style.borderRadius
    @IBInspectable var borderWidth: CGFloat = Style.borderWidth

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // draw the layout
        
        self.layer.borderWidth = self.borderWidth
        self.layer.cornerRadius = self.borderRadius
        self.titleLabel?.numberOfLines = 2
    }
}
