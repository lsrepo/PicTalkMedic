//
//  ContextCollectionView.swift
//  PicTalkMedic
//
//  Created by Pak on 03/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import Foundation
import UIKit

class ContextCollectionView: PicTalkCollectionView
{
    
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("cellForItemAtIndexPath")
        
        // create a cell, change its text
        let cell = ContextCollectionViewCell()
        
        // standard
        if let headCell = self.dequeueReusableCellWithReuseIdentifier("HeadCell", forIndexPath: indexPath) as? ContextCollectionViewCell{
            print("inside head cell")
            headCell.text.text = dataItems[indexPath.item].swedish
            return headCell
        }
        
        return cell
    }
    
    
    
    
    
}