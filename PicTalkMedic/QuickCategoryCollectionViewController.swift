//
//  QuickCategoryCollectionViewController.swift
//  PicTalkMedic
//
//  Created by Pak on 10/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit

class QuickCategoryCollectionView: ContextCollectionView {
  
    
    override  func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        
        let tappedIndex = (indexPath as NSIndexPath).item
        eventDidSelectWithIndexOf(tappedIndex,guardEnabled: false)
        
        selectedCategoryIndexPath = indexPath
        selectedIndexPath = selectedCategoryIndexPath
        resetStyle()
        childCollectionView.reloadData()
        self.reloadData()
    }
    
 
    
}
