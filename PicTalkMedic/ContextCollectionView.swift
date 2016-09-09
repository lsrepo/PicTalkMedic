//
//  self.swift
//  PicTalkMedic
//
//  Created by Pak on 03/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import Foundation
import UIKit

class ContextCollectionView: PicTalkCollectionView
{
   
    
    var childCollectionView: WordCollectionView!
    var mainCategoryIsSelected = true
    var selectedMainContext = ""
    
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("cellForItemAtIndexPath")
        
        // create a cell, change its text
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HeadCell", forIndexPath: indexPath) as! ContextCollectionViewCell
       
        cell.text.text = dataItems[indexPath.item].swedish
     
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)!
        
        if let selectedHeadCell = selectedCell as? ContextCollectionViewCell{
            
            //switch
            
            let tappedIndex = indexPath.item
            let tappedItem = dataItems[tappedIndex]
            
            // 1. Distinguish the level we are at : main or sub
            if (mainCategoryIsSelected){
                // the tabbed item belongs to main category
                selectedMainContext = tappedItem.parent
                
                // A. populate data in context collection with..
                //-----------------------------------------------
                // expectation: reception , consulation
                if let mainContextItems = picDatabase[selectedMainContext]{
                    
                    // B. populate data in word collection with..
                    //--------------------------------------------
                    // expectation: identify , pay  ( subcontext of reception )
                    if let firstSubContext = mainContextItems.first?.contain{
                        
                        // expectation: words
                        if let firstSubContextWords = picDatabase[firstSubContext] {
                            //populate the data in word collection with the first
                            childCollectionView.dataItems = firstSubContextWords
                            childCollectionView.reloadData()
                        }
                    }
                }
                

                // 2. Change the items in context view - no need to preselect anything
                
                if let selectedSubContext = tappedItem.contain{
                    
                    //Debug, clean self
                    self.dataItems.removeAll()
                    
                    // A. Populate context view data with the sub contexts
                    //----------------------------------------------------
                    print("selectedSubContext:",selectedSubContext)
                    if let selectedSubContextItems = picDatabase[selectedSubContext]{
                        self.dataItems = selectedSubContextItems
                    }
                    
                    // B. Insert backButton
                    //----------------------------------------------------
                    let backButton = DataItem(swedish: "back", arabic: "back", picName: "back", parent: "system", contain: nil)
                    self.dataItems.insert(backButton, atIndex: 0)
                    
                    
                }
                
                // 3. set mainCIS to false
                //----------------------------------------------------
                mainCategoryIsSelected = false
                
                // 4. select first
                //----------------------------------------------------
                
                
            }
            else{
                
                print("tappedIndex: ",tappedIndex)
                
                // guard: if the back button is not tapped
                //----------------------------------------------------
                guard (tappedIndex != 0)else{
                    print(" in guard else")
                    // 1. change the items in context view to main
                    
                    
                    
                    
                    if let contextItems = picDatabase["context"]{
                        print("contextItems:",contextItems)
                        self.dataItems = contextItems
                    }
                    
                    self.reloadData()
                    // TODO: 1.5  copy previous code
                    
                    // 2. set mainCIS to true
                    mainCategoryIsSelected = true
                    return
                }
                
                
                // Tapped is not the back button
                //----------------------------------------------------
                
                // 1. populate the data in word collection
                //----------------------------------------------------
                if let selectedSubContext = tappedItem.contain{
                    if let words = picDatabase[selectedSubContext]{
                        childCollectionView.dataItems = words
                        childCollectionView.reloadData()
                    }
                }
                
                // TODO: 2. change the items in context view to sub
                
                
            }
            
        }
         reloadData()
    }
    
    
    
}