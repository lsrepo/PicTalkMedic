//
//  WordCollectionViewCell.swift
//  PicTalkMedic
//
//  Created by Pak on 31/08/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit
@IBDesignable
class WordCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var text: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!

    func switchGender(){
        backgroundColor = UIColor.redColor()
        
    }
    
    @IBInspectable var borderRadius: CGFloat = Style.borderRadius
    @IBInspectable var borderWidth: CGFloat = Style.borderWidth
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        // draw the layout
        
        self.layer.borderWidth = self.borderWidth
        self.layer.cornerRadius = self.borderRadius
        
    }
    
}


struct Style{
    static let borderRadius:CGFloat = 5
    static let borderWidth:CGFloat  = 1
}