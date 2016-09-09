//
//  PicTalkCollectionView.swift
//  PicTalkMedic
//
//  Created by Pak on 07/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import Foundation
import UIKit

class PicTalkCollectionView:UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var dataItems:[DataItem] = [DataItem]()
    var picDatabase:PicTable!
     
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    // MARK: DataSource
    
    
  
}