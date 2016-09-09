//
//  UtterColelctionView.swift
//  PicTalkMedic
//
//  Created by Pak on 02/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit

class MessageColelctionView:  PicTalkCollectionView {

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MsgCell", forIndexPath: indexPath) as! MessageCollectionViewCell
        
        // Configure the cell
        print("configure message cell")
        //cell.text.text = dataItems[indexPath.item].swedish
        cell.imageView.image = dataItems[indexPath.item].pic
        
        return cell
    }
    
}
