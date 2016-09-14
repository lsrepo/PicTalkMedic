//
//  WordCollectionView.swift
//  PicTalkMedic
//
//  Created by Pak on 03/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit

class WordCollectionView: PicTalkCollectionView {
    
    var messageView:MessageColelctionView!
   

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SubCell", forIndexPath: indexPath) as! WordCollectionViewCell
        
        // Configure the cell
        
        cell.text.text = textInSelectedLang(dataItems[indexPath.item])
        cell.imageView.image = dataItems[indexPath.item].pic
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        print("a word is selected")
        let selectedItem =  dataItems[indexPath.item]
        messageView.addItem(selectedItem)
        messageView.reloadData()
  
    }
  
    
}
