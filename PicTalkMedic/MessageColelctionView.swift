//
//  UtterColelctionView.swift
//  PicTalkMedic
//
//  Created by Pak on 02/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit

class MessageColelctionView:  PicTalkCollectionView  {
    
    weak var messageDataDelegate:  MessageDataDelegate?
   // var sharedParams: SharedParams!
    
    
    func didSwipe(recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.Ended {
            print("swipe ended msg")
        }
    }
    
   
    
    override var dataItems:[DataItem] {
        didSet{
            messageDataDelegate?.updateMessageDisplay(getMessageText())
        }
    }
    
    
    func getMessageText() -> String{
        var text = ""
        for item in dataItems {
            switch sharedParams.selectedLang{
            case .swedish:
                text += item.swedish + "      "
            case .arabic:
                 text += item.arabic + "      "
            default:
                break
            }
        }
        return text
    }
    
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MsgCell", forIndexPath: indexPath) as! MessageCollectionViewCell
        
        // Configure the cell
        print("configure message cell")
        //cell.text.text = dataItems[indexPath.item].swedish
        cell.imageView.image = dataItems[indexPath.item].pic
        
        return cell
    }
    
}
