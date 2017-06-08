//
//  MessageCollectionViewCell.swift
//  PicTalkMedic
//
//  Created by Pak on 03/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit

@IBDesignable


class MessageCollectionViewCell: UICollectionViewCell{
    

    @IBOutlet weak var imageView: UIImageView!
    @IBInspectable var borderRadius: CGFloat = Style.borderRadius
    @IBInspectable var borderWidth: CGFloat = Style.borderWidth
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // draw the layout
        
        self.layer.borderWidth = self.borderWidth
        self.layer.cornerRadius = self.borderRadius
        
    }
    
    var data:DataItem!
    var itemIndex:Int!
}
