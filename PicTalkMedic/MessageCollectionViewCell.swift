//
//  MessageCollectionViewCell.swift
//  PicTalkMedic
//
//  Created by Pak on 03/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit

@IBDesignable


class MessageCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var imageView: UIImageView!
    @IBInspectable var borderRadius: CGFloat = 5
    @IBInspectable var borderWidth: CGFloat = 1
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        // draw the layout
        
        self.layer.borderWidth = self.borderWidth
        self.layer.cornerRadius = self.borderRadius
        
    }
}
