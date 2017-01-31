//
//  UtterColelctionView.swift
//  PicTalkMedic
//
//  Created by Pak on 02/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit

class MessageColelctionView:  PicTalkCollectionView, UIGestureRecognizerDelegate  {
    
   
    var questionMarkItem:DataItem {
        get{
            
            switch sharedParams.selectedLang{
            case .swedish:
                return DataItem(swedish: "?", arabic: "⸮", picName: "questionMark", parent: nil, child: nil)
            case .arabic:
                return DataItem(swedish: "?", arabic: "⸮", picName: "questionMarkReversed", parent: nil, child: nil)
            default:
                return DataItem(swedish: "?", arabic: "⸮", picName: "questionMark", parent: nil, child: nil)
            }
            
        }
    }
    
    var isQuestion = false {
        willSet(newValue) {
            if (newValue){
                
                dataItems.append(questionMarkItem)
            }else{
                //print("false")
                if (dataItems.count > 0){
                    dataItems.removeLast()
                }
                
            }
        }
        
    }
    
    weak var messageDataDelegate:  MessageDataDelegate?
    // var sharedParams: SharedParams!
    
    
    func didSwipe(_ recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.ended {
            print("swipe ended msg")
        }
    }
    
    
    
    override var dataItems:[DataItem] {
        didSet{
            messageDataDelegate?.updateMessageDisplay(getMessageText(lang:sharedParams.selectedLang))
            
            if(dataItems.count > 0 ){
                messageDataDelegate?.activateClearButton()
            }else{
                messageDataDelegate?.deactivateClearButton()
            }
        }
    }
    
    func reverseDataItems(){
        dataItems = dataItems.reversed()
        //print("data is reversed")
    }
    
    func addItem(_ item:DataItem){
        
        if (isQuestion){
            // remove ?
            if (dataItems.count > 0){
                dataItems.removeLast()
            }
            dataItems.append(item)
            dataItems.append(questionMarkItem)
        }else{
            dataItems.append(item)
        }
        
    }
    
    func getMessageText(lang:Language) -> String{
        var text = ""
        for item in dataItems {
            //print(" item is ", item.swedish )
            switch lang{
            case .swedish:
                text += item.swedish! + Constants.textSeperator
            case .arabic:
                text += item.arabic! + Constants.textSeperator
            default:
                break
            }
        }
        //print("getMessageText: ",text)
        return text
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MsgCell", for: indexPath) as! MessageCollectionViewCell
        
        // Configure the cell
       
        
        // sequence
        switch sharedParams.selectedLang{
        case .arabic:
            // reverse the pic
            let maxIndex = dataItems.count - 1
            
            let dataItem = dataItems[maxIndex - (indexPath as NSIndexPath).item]
            cell.data = dataItem
            cell.imageView.image = dataItem.pic
            cell.itemIndex = maxIndex - (indexPath as NSIndexPath).item
            
            // handle question mark
            if ( indexPath.item == 0 && isQuestion ){
                print(" this is ?")
                cell.imageView.image = questionMarkItem.pic
            }
        case .swedish:
            let dataItem = dataItems[(indexPath as NSIndexPath).item]
            cell.data = dataItem
            cell.imageView.image = dataItem.pic
            cell.itemIndex = (indexPath as NSIndexPath).item
            
            // handle question mark
            if ( indexPath.item == dataItems.count-1 && isQuestion  ){
                print(" this is ?")
                cell.imageView.image = questionMarkItem.pic
            }
        default:
            break
        }
        
        // add gestures
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeToRemove(gestureReconizer:)))
        upSwipe.direction = UISwipeGestureRecognizerDirection.up
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeToRemove(gestureReconizer:)))
        downSwipe.direction = UISwipeGestureRecognizerDirection.down
        
        
        cell.addGestureRecognizer(upSwipe)
        cell.addGestureRecognizer(downSwipe)
        return cell
    }
    
 
    func swipeToRemove(gestureReconizer:UIGestureRecognizer){
        
        let not = gestureReconizer.numberOfTouches
        
        if let cell = gestureReconizer.view as? MessageCollectionViewCell{
            print("-------")
            print(cell)
            
            
            if (cell.data.swedish == "?"){
                messageDataDelegate?.deactivateQuestionMode()
            }else{
                let count = self.dataItems.count
                // prevent multi swipes -- safe bet
                guard (cell.itemIndex < count)else{
                    print("danger")
                    //self.reloadData()
                    return
                }
                
                self.dataItems.remove(at: cell.itemIndex)
          
                
            }

            self.reloadData()
            
        }
    }
    
    
}
