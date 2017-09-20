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
        backgroundColor = UIColor.red
        
    }
    
    @IBInspectable var borderRadius: CGFloat = Style.borderRadius
    @IBInspectable var borderWidth: CGFloat = Style.borderWidth
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // draw the layout
        
        self.layer.borderWidth = self.borderWidth
        self.layer.cornerRadius = self.borderRadius
        self.backgroundColor = Style.wordCellBackgroundColor
        
    }
    
    func tapped() {
        

        UIView.animate(withDuration: 0.3, animations: {
            self.layer.borderColor = UIColor(red:0.97, green:0.65, blue:0.11, alpha:1.0).cgColor
        })
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { timer in
            UIView.animate(withDuration: 0.3, animations: {
                self.layer.borderColor = UIColor.black.cgColor
            })
        }
        
        
    }
    
}


