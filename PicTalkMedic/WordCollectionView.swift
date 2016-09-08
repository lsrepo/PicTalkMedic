//
//  WordCollectionView.swift
//  PicTalkMedic
//
//  Created by Pak on 03/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit

class WordCollectionView:  PicTalkCollectionView {

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("cellForItemAtIndexPath")
        
        // create a cell, change its text
        let cell = WordCollectionViewCell()
        
        // standard
        if let subCell = self.dequeueReusableCellWithReuseIdentifier("SubCell", forIndexPath: indexPath) as? WordCollectionViewCell{
            print("inside head cell")
            subCell.text.text = dataItems[indexPath.item].swedish
            subCell.imageView.image = dataItems[indexPath.item].pic
            return subCell
        }
        
        return cell
    }
    
    
}
