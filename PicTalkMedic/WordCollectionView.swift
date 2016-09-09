//
//  WordCollectionView.swift
//  PicTalkMedic
//
//  Created by Pak on 03/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit

class WordCollectionView: PicTalkCollectionView {

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SubCell", forIndexPath: indexPath) as! WordCollectionViewCell
        
        // Configure the cell
        print("inside head cell")
        cell.text.text = dataItems[indexPath.item].swedish
        cell.imageView.image = dataItems[indexPath.item].pic
        
        return cell
    }
    
  
    
}
