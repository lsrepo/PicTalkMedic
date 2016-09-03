//
//  WordCollectionViewCell.swift
//  PicTalkMedic
//
//  Created by Pak on 31/08/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit

class WordCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var text: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!

    func switchGender(){
        backgroundColor = UIColor.redColor()
        
    }
    
    
}
