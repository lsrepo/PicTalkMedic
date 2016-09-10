//
//  QuickCategoryCollectionViewController.swift
//  PicTalkMedic
//
//  Created by Pak on 10/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit

class QuickCategoryCollectionView: ContextCollectionView {
  
    
    override  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let tappedIndex = indexPath.item
        eventDidSelectWithIndexOf(tappedIndex,guardEnabled: false)
        childCollectionView.reloadData()
    }
    

}
