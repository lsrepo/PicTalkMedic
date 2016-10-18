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
    var grandParent = "context"
    var selectedEventIndexPath:IndexPath = IndexPath(item: 1, section: 0)
    var selectedCategoryIndexPath:IndexPath = IndexPath()
    var selectedIndexPath:IndexPath = IndexPath()
    

    
    // MARK: DataSource
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        // create a cell, change its text
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeadCell", for: indexPath) as! ContextCollectionViewCell
       
        cell.text.text = textInSelectedLang(dataItems[(indexPath as NSIndexPath).item])
        cell.data = dataItems[(indexPath as NSIndexPath).item]
        
        //image
        
        cell.imageView.image = dataItems[(indexPath as NSIndexPath).item].getPic(selectedGender: sharedParams.selectedGender)
        
        // need this when language is changed
        
        if selectedIndexPath == indexPath{
              cell.isSelected = true
        }else{
              cell.isSelected = false
        }
      
       
        return cell
    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {

        let tappedIndex = (indexPath as NSIndexPath).item
        
        // 0. utter
        utter(selectedItem: dataItems[tappedIndex])
        
        // 1. Distinguish the level we are at : main or sub
        if (contextIsSelected){
            
            selectedCategoryIndexPath = indexPath
            contextDidSelectWithIndexOf(tappedIndex)
            selectedEventIndexPath = IndexPath(item: 1, section: 0)
            selectedIndexPath = selectedEventIndexPath

        }
        else{
            selectedEventIndexPath = indexPath
            eventDidSelectWithIndexOf(tappedIndex,guardEnabled: true)
          
        }
        
      
        reloadData()
        
    }
    
    
    
    //MARK: When a context is selected
    


    
    func loadWordsOfSelectedContext(_ selectedContext:String){
        // A. populate data in context collection with..
        //-----------------------------------------------
        // expectation: reception , consulation
        if let mainContextItems = picDatabase[selectedContext]{
            //print("mainContextItems",mainContextItems)
            // B. populate data in word collection with..
            //--------------------------------------------
            // expectation: identify , pay  ( subcontext of reception )
            if let firstSubContext = mainContextItems.first?.child{
                //print("firstSubContext",firstSubContext)
                // expectation: identify, payment

                if let firstSubContextWords = picDatabase[firstSubContext] {
                    
                    //populate the data in word collection with the first
                    childCollectionView.dataItems = firstSubContextWords
                    childCollectionView.reloadData()
                    
                  
                }
            }
        }
    }
    
    /// 2. Change the items in context view - no need to preselect anything
    func loadEventsOfSelectedContextWithTappedItem(_ tappedItem:DataItem){
        
        if let selectedSubContext = tappedItem.child{
            
            //Debug, clean self
            self.dataItems.removeAll()
            
            // A. Populate context view data with the sub contexts
            //----------------------------------------------------
            ////print("selectedSubContext:",selectedSubContext)
            if let selectedSubContextItems = picDatabase[selectedSubContext]{
                self.dataItems = selectedSubContextItems
            }
            
            // B. Insert backButton
            //----------------------------------------------------
            let backButton = DataItem(swedish: "tillbaka",  arabic: "⸮",arabicFemale: nil ,picName: "tillbaka", parent: "system", child: nil)
            self.dataItems.insert(backButton, at: 0)
            
            
        }
    }
    
    
    func contextDidSelectWithIndexOf(_ tappedIndex:Int){
        let tappedItem = dataItems[tappedIndex]
        // the tabbed item belongs to main category
        
        // 1. Load words of selected item in the word collection view
        if let selectedContext = tappedItem.child {
            loadWordsOfSelectedContext(selectedContext)
        }
        
        // 2. Change the items in context view - pre select the first
        loadEventsOfSelectedContextWithTappedItem(tappedItem)
        
        // 3. set mainCIS to false
        //----------------------------------------------------
        contextIsSelected = false
        
        // 4. prevent forgetting the selected context
        selectedIndexPath = selectedCategoryIndexPath
        
       
        
    }
    
    
    
    //MARK: When an event is selected
    
    func eventDidSelectWithIndexOf(_ tappedIndex:Int,guardEnabled:Bool){
        let tappedItem = dataItems[tappedIndex]
        
        
        // guard: if the back button is not tapped
        //----------------------------------------------------
        guard (tappedIndex != 0 || guardEnabled == false )else{
            //print(" in guard else")
            // 1. change the items in context view to main
            
            if let contextItems = picDatabase[grandParent]{
                //print("contextItems:",contextItems)
                self.dataItems = contextItems
            }
            
            self.reloadData()
            // TODO: 1.5  copy previous code
            
            // 2. set mainCIS to true
            contextIsSelected = true
            
            // 3. delete items in word colelction
            childCollectionView.dataItems.removeAll()
            childCollectionView.reloadData()
            
            // 4. empty selectedIndexPath
            selectedIndexPath = IndexPath()
            return
        }
        
        
        // Tapped is not the back button
        //----------------------------------------------------
        
        // 1. populate the data in word collection
        //----------------------------------------------------
        if let selectedSubContext = tappedItem.child{
            if let words = picDatabase[selectedSubContext]{
                childCollectionView.dataItems = words
                childCollectionView.reloadData()
            }
        }
        
        
        // 2.
        
        // 3. Prevent forgetting the selected event
        selectedIndexPath = selectedEventIndexPath
        
        
        
    }
    
    // MARK: remove
    
 
    
    
}
