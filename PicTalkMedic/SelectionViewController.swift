//
//  SelectionViewController.swift
//  PicTalkMedic
//
//  Created by Pak on 03/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {
    
    var data = [PicTalkCollectionView]()
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.data = [messageCollectionView, contextCollectionView ,wordCollectionView]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: UICollectionViwe delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[collectionView.tag].dataItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        switch collectionView.tag {
        //Main
        case 1:
            if let headCell = collectionView.dequeueReusableCellWithReuseIdentifier("HeadCell", forIndexPath: indexPath) as? ContextCollectionViewCell{
                if let view = data[collectionView.tag] as? ContextCollectionView{
                    headCell.text.text = view.dataItems[indexPath.item].swedish
                    cell =  headCell
                }
            }
            
        //Sub
        case 2:
            if let subCell = collectionView.dequeueReusableCellWithReuseIdentifier("SubCell", forIndexPath: indexPath) as? WordCollectionViewCell{
                if let view = data[collectionView.tag] as? WordCollectionView{
                    subCell.text.text = view.dataItems[indexPath.item].swedish
                    subCell.imageView.image = view.dataItems[indexPath.item].pic
                    cell =  subCell
                }
            }
        case 0:
            if let msgCell = collectionView.dequeueReusableCellWithReuseIdentifier("MsgCell", forIndexPath: indexPath) as? MessageCollectionViewCell{
                if let view = data[collectionView.tag] as? MessageColelctionView{
                    msgCell.imageView.image = view.dataItems[indexPath.item].pic
                    cell =  msgCell
                }
            }
            
        default:
            break
        }
        
        cell.hidden = false
        
        if let kdCollectionView = collectionView as? KDDragAndDropCollectionView {
            
            if let draggingPathOfCellBeingDragged = kdCollectionView.draggingPathOfCellBeingDragged {
                
                if draggingPathOfCellBeingDragged.item == indexPath.item {
                    
                    cell.hidden = true
                    
                }
            }
        }
        return cell
    }
    
    var mainCategoryIsSelected = true
    var selectedMainContext = ""
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)!
        print("didSelectItemAtIndexPath")
        switch collectionView.tag {
        //Main
        case 1:
            if let selectedHeadCell = selectedCell as? ContextCollectionViewCell{
                //appearance
                selectedHeadCell.backgroundColor = UIColor.blackColor()
                selectedHeadCell.text.textColor = UIColor.whiteColor()
                
             
                //switch
                
                let tappedIndex = indexPath.item
                let tappedItem = data[collectionView.tag].dataItems[tappedIndex]
                
                // 1. Distinguish the level we are at : main or sub
                if (mainCategoryIsSelected){
                    // the tabbed item belongs to main category
                    selectedMainContext = tappedItem.parent
                    
                    // A. populate data in context collection with..
                    //-----------------------------------------------
                    // expectation: reception , consulation
                    if let mainContextItems = categorizedData[selectedMainContext]{
                        
                        // B. populate data in word collection with..
                        //--------------------------------------------
                        // expectation: identify , pay  ( subcontext of reception )
                        if let firstSubContext = mainContextItems.first?.contain{
                            
                            // expectation: words
                            if let firstSubContextWords = categorizedData[firstSubContext] {
                                //populate the data in word collection with the first
                                data[2].dataItems = firstSubContextWords
                                wordCollectionView.reloadData()
                            }
                        }
                    }
                    
                    
                    // 2. Change the items in context view - no need to preselect anything
                    
                    if let selectedSubContext = tappedItem.contain{
                        
                        //Debug, clean data[1]
                        data[1].dataItems.removeAll()
                        
                        // A. Populate context view data with the sub contexts
                        //----------------------------------------------------
                        print("selectedSubContext:",selectedSubContext)
                        if let selectedSubContextItems = categorizedData[selectedSubContext]{
                            data[1].dataItems = selectedSubContextItems
                        }
                        
                        // B. Insert backButton
                        //----------------------------------------------------
                        let backButton = DataItem(swedish: "back", arabic: "back", picName: "back", parent: "system", contain: nil)
                        data[1].dataItems.insert(backButton, atIndex: 0)
                        
                        contextCollectionView.reloadData()
                        
                    }
                    
                    // 3. set mainCIS to false
                    //----------------------------------------------------
                    mainCategoryIsSelected = false
                    
                    // 4. select first
                    //----------------------------------------------------
                    
                    
                }else{
                    
                    print("tappedIndex: ",tappedIndex)
                    
                    // guard: if the back button is not tapped
                    //----------------------------------------------------
                    guard (tappedIndex != 0)else{
                        print(" in guard else")
                        // 1. change the items in context view to main
                        
                        
                        
                        
                        if let contextItems = categorizedData["context"]{
                            print("contextItems:",contextItems)
                            data[1].dataItems = contextItems
                        }
                        contextCollectionView.reloadData()
                        // TODO: 1.5  copy previous code
                        
                        // 2. set mainCIS to true
                        mainCategoryIsSelected = true
                        break;
                    }
                    
                    
                    // Tapped is not the back button
                    //----------------------------------------------------
                    
                    // 1. populate the data in word collection
                    //----------------------------------------------------
                    if let selectedSubContext = tappedItem.contain{
                        if let words = categorizedData[selectedSubContext]{
                            data[2].dataItems = words
                            wordCollectionView.reloadData()
                        }
                    }
                    
                    // TODO: 2. change the items in context view to sub
                    
                    
                }
            }
            
        //Sub
        case 2:
            if let selectedCell = selectedCell as? WordCollectionViewCell{
                let text = selectedCell.text.text!
                
                utteranceQueue.append(indexPath)
                utter(text)
            }
            
        default:
            break
        }
        
    }


}
