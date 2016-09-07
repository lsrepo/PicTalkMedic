//
//  ViewController.swift
//  PicTalkMedic
//
//  Created by Pak on 29/08/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, AVSpeechSynthesizerDelegate,KDDragAndDropCollectionViewDataSource  {
    
    
    //MARK: Outlets
    
    //Text
    @IBOutlet weak var messageDisplay: UILabel!
    
    //Buttons
    @IBOutlet weak var speakButton: UIButton!
    @IBAction func utterMessage(sender: UIButton) {
        let text = getMessageText()
        utter(text)
    }
    //Buttons Touch Events
    @IBAction func switchGender(sender: AnyObject) {
        let cells = wordCollectionView.visibleCells()
        for cell in cells{
            if let castedCell = cell as? WordCollectionViewCell{
                castedCell.switchGender()
            }
        }
        
    }
    @IBAction func switchLang(sender: UIButton) {
    }
    
    //Collection Views
    weak var messageCollectionView: MessageColelctionView!
    @IBOutlet weak var contextCollectionView: ContextCollectionView!
    @IBOutlet weak var wordCollectionView: WordCollectionView!
    
    
    //MARK: Variables
    
    var dragAndDropManager : KDDragAndDropManager?
    var selectedSub = 0
    var data = [PicTalkCollectionView]()
    let selectedLang = "en-UK"
    
    let categorizedData = DataManager().importData("test")
    
   
    
    //Message Area
    var message:[DataItem]  = {
        var dataItem = [DataItem]()
        return dataItem
    }()
    
    
    // MARK: VidedidLoad
    
    override func viewDidAppear(animated: Bool) {
        
        contextCollectionView.reloadData()
        wordCollectionView.reloadData()
        messageCollectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionViewConfig(wordCollectionView)
        collectionViewConfig(contextCollectionView)
        
        // headCellWords.con
        synthesizer.delegate = self
        
        
        
        // Drag and drop
        self.dragAndDropManager = KDDragAndDropManager(canvas: self.view, collectionViews: [messageCollectionView, wordCollectionView, ])
        print("categorizedData: \n")
        print(categorizedData)
        
        // assign all the contexts to the data in context view.
        // i.e. expectation = reception , consulation
        if let contextItems = categorizedData["context"]{
            contextCollectionView.dataItems = contextItems
        }
        
        
        //a 3d array for data
        self.data = [messageCollectionView, contextCollectionView ,wordCollectionView]
        
        //select the first category
    }
    
    func collectionViewConfig(collv:UICollectionView){
        collv.delegate = self
        collv.dataSource = self
        
        //Style
        collv.backgroundColor = UIColor.whiteColor()
        
        //Interaction
        collv.userInteractionEnabled = true
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
                
                //utter
                selectedSub = indexPath.item
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
    
    
    
    // MARK : KDDragAndDropCollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, dataItemForIndexPath indexPath: NSIndexPath) -> AnyObject {
        return data[collectionView.tag].dataItems[indexPath.item]
    }
    func collectionView(collectionView: UICollectionView, insertDataItem dataItem : AnyObject, atIndexPath indexPath: NSIndexPath) -> Void {
        
        if let di = dataItem as? DataItem {
            data[collectionView.tag].dataItems.insert(di, atIndex: indexPath.item)
        }
        
        
    }
    func collectionView(collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath : NSIndexPath) -> Void {
        data[collectionView.tag].dataItems.removeAtIndex(indexPath.item)
    }
    
    func collectionView(collectionView: UICollectionView, moveDataItemFromIndexPath from: NSIndexPath, toIndexPath to : NSIndexPath) -> Void {
        print("moveDataItemFromIndexPath")
        let fromDataItem: DataItem = data[collectionView.tag].dataItems[from.item]
        data[collectionView.tag].dataItems.removeAtIndex(from.item)
        data[collectionView.tag].dataItems.insert(fromDataItem, atIndex: to.item)
        
        //called when user move items with in one collection view and across  collection views
        updateMessageDisplay()
        
        
    }
    
    func collectionView(collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> NSIndexPath? {
        
        if let candidate : DataItem = dataItem as? DataItem {
            
            for item : DataItem in data[collectionView.tag].dataItems {
                if candidate  == item {
                    
                    let position = data[collectionView.tag].dataItems.indexOf(item)! // ! if we are inside the condition we are guaranteed a position
                    let indexPath = NSIndexPath(forItem: position, inSection: 0)
                    return indexPath
                }
            }
        }
        
        return nil
        
    }
    
    //    MARK: Utterance & Synthesizer
    let synthesizer = AVSpeechSynthesizer()
    var utteranceQueue = [NSIndexPath]()
    
    func getMessageText() -> String{
        let dataItems = data[messageCollectionView.tag].dataItems
        var text = ""
        for d in dataItems {
            text += d.swedish + "      "
        }
        return text
    }
    
    func updateMessageDisplay(){
        messageDisplay.text = getMessageText()
    }
    
    func utter(text:String){
        //action
        let utter = AVSpeechUtterance(string: text)
        utter.voice = AVSpeechSynthesisVoice(language: selectedLang)
        synthesizer.speakUtterance(utter)
        
    }
    
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        
        if let item = utteranceQueue.first{
            contextCollectionView.cellForItemAtIndexPath(item)?.alpha = 1
            utteranceQueue.removeFirst()
            
        }
        
    }
    
    
}
