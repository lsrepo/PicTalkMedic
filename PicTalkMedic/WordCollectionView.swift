//
//  WordCollectionView.swift
//  PicTalkMedic
//
//  Created by Pak on 03/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit
import AVFoundation

class WordCollectionView: PicTalkCollectionView {
    
    var messageView:MessageColelctionView!
   

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCell", for: indexPath) as! WordCollectionViewCell
        
        // Configure the cell
        
        cell.text.text = textInSelectedLang(dataItems[(indexPath as NSIndexPath).item])
        cell.imageView.image = dataItems[(indexPath as NSIndexPath).item].pic
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {

        //print("a word is selected")
        let selectedItem =  dataItems[(indexPath as NSIndexPath).item]
        messageView.addItem(selectedItem)
        messageView.reloadData()
        
        // visual effect
        if let cell = collectionView.cellForItem(at: indexPath) as? WordCollectionViewCell {
            cell.tapped()
        }
        
        // sound
        utter(selectedItem: selectedItem)
    }
    
   
    
}
