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
    var contextIsSelected = true
    
    
    // MARK: DataSource
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        // create a cell, change its text
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HeadCell", forIndexPath: indexPath) as! ContextCollectionViewCell
       
        cell.text.text = dataItems[indexPath.item].swedish
     
        return cell
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)!
        
        if let selectedHeadCell = selectedCell as? ContextCollectionViewCell{
            
            let tappedIndex = indexPath.item
            
            // 1. Distinguish the level we are at : main or sub
            if (contextIsSelected){
                contextDidSelectWithIndexOf(tappedIndex)
            }
            else{
                eventDidSelectWithIndexOf(tappedIndex)
            }
        }
        reloadData()
    }
    
    //MARK: When a context is selected
    
    func loadWordsOfSelectedContext(selectedContext:String){
        // A. populate data in context collection with..
        //-----------------------------------------------
        // expectation: reception , consulation
        if let mainContextItems = picDatabase[selectedContext]{
            print("mainContextItems",mainContextItems)
            // B. populate data in word collection with..
            //--------------------------------------------
            // expectation: identify , pay  ( subcontext of reception )
            if let firstSubContext = mainContextItems.first?.contain{
                print("firstSubContext",firstSubContext)
                // expectation: identify, payment
                if let firstSubContextWords = picDatabase[firstSubContext] {
                    
                    //populate the data in word collection with the first
                    childCollectionView.dataItems = firstSubContextWords
                    print("firstSubContextWords",firstSubContextWords)
                    print(firstSubContextWords.first!.swedish)
                    childCollectionView.reloadData()
                }
            }
        }
    }
    
    /// 2. Change the items in context view - no need to preselect anything
    func loadEventsOfSelectedContextWithTappedItem(tappedItem:DataItem){
        
        if let selectedSubContext = tappedItem.contain{
            
            //Debug, clean self
            self.dataItems.removeAll()
            
            // A. Populate context view data with the sub contexts
            //----------------------------------------------------
            //print("selectedSubContext:",selectedSubContext)
            if let selectedSubContextItems = picDatabase[selectedSubContext]{
                self.dataItems = selectedSubContextItems
            }
            
            // B. Insert backButton
            //----------------------------------------------------
            let backButton = DataItem(swedish: "back", arabic: "back", picName: "back", parent: "system", contain: nil)
            self.dataItems.insert(backButton, atIndex: 0)
            
            
        }
    }
    
    
    func contextDidSelectWithIndexOf(tappedIndex:Int){
        let tappedItem = dataItems[tappedIndex]
        // the tabbed item belongs to main category
        
        // 1. Load words of selected item in the word collection view
        if let selectedContext = tappedItem.contain {
            loadWordsOfSelectedContext(selectedContext)
        }
        
        // 2. Change the items in context view - no need to preselect anything
        loadEventsOfSelectedContextWithTappedItem(tappedItem)
        
        // 3. set mainCIS to false
        //----------------------------------------------------
        contextIsSelected = false
    }
    
    
    
    //MARK: When an event is selected
    
    func eventDidSelectWithIndexOf(tappedIndex:Int){
        let tappedItem = dataItems[tappedIndex]
        
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
            contextIsSelected = true
            
            // 3. delete items in word colelction
            childCollectionView.dataItems.removeAll()
            childCollectionView.reloadData()
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