//
//  HeadCollectionViewCell.swift
//  PicTalkMedic
//
//  Created by Pak on 30/08/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit
@IBDesignable
class ContextCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var text: UILabel!
    
    @IBInspectable var borderRadius: CGFloat = Style.borderRadius
    @IBInspectable var borderWidth: CGFloat = Style.borderWidth
   
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // draw the layout
        
        self.layer.borderWidth = self.borderWidth
        self.layer.cornerRadius = self.borderRadius
        self.backgroundColor = Style.contextCellBackgroundColor
    }
    
    
}
