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
    var sharedParams: SharedParams!
     
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
    // MARK: Language
    
    func textInSelectedLang(_ dataItem:DataItem) -> String? {
        switch sharedParams.selectedLang{
        case .swedish:
            return dataItem.swedish
        case .arabic:
            return dataItem.arabic
        default:
            return ""
        }
    }
  
}
