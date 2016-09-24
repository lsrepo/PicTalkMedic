//
//  UtterColelctionView.swift
//  PicTalkMedic
//
//  Created by Pak on 02/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit

class MessageColelctionView:  PicTalkCollectionView  {
    let questionMarkItem = DataItem(swedish: "?", arabic: "?", picName: "questionMark", parent: nil, child: nil)
    
    var isQuestion = false {
        willSet(newValue) {
            if (newValue){
                print("tru")
                dataItems.append(questionMarkItem)
            }else{
                print("false")
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
            print("In dataItems, getMessageText():",getMessageText())
            messageDataDelegate?.updateMessageDisplay(getMessageText())
        }
    }
    
    func reverseDataItems(){
        dataItems = dataItems.reversed()
        print("data is reversed")
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
    
    func getMessageText() -> String{
        var text = ""
        for item in dataItems {
            print(" item is ", item.swedish )
            switch sharedParams.selectedLang{
            case .swedish:
                text += item.swedish! + "      "
            case .arabic:
                 text += item.arabic! + "      "
            default:
                break
            }
        }
        print("getMessageText: ",text)
        return text
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MsgCell", for: indexPath) as! MessageCollectionViewCell
        
        // Configure the cell
        
        switch sharedParams.selectedLang{
        case .arabic:
            // reverse the pic
            let maxIndex = dataItems.count - 1
            cell.imageView.image = dataItems[maxIndex - (indexPath as NSIndexPath).item].pic
        case .swedish:
           cell.imageView.image = dataItems[(indexPath as NSIndexPath).item].pic
        default:
            break
        }
        
        
        return cell
    }
    
}
