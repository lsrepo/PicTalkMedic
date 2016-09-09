//
//  ViewController.swift
//  PicTalkMedic
//
//  Created by Pak on 29/08/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, AVSpeechSynthesizerDelegate  {
    
    
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
    @IBOutlet weak var messageCollectionView: MessageColelctionView!
    @IBOutlet weak var contextCollectionView: ContextCollectionView!
    @IBOutlet weak var wordCollectionView: WordCollectionView!
    
    
    //MARK: Variables
    
    //var dragAndDropManager : KDDragAndDropManager?
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
 
        
        // headCellWords.con
        synthesizer.delegate = self
        
        
        setUpContextCV()
        setUpWordCV()
        
        //a 3d array for data
        self.data = [messageCollectionView, messageCollectionView ,wordCollectionView]
        
        //select the first category
    }
    
    func setUpContextCV(){

        passDataToCollectionView(categorizedData, field: "context", collectionView: contextCollectionView)
        
        // Set up delegation
        contextCollectionView.delegate = contextCollectionView
        contextCollectionView.childCollectionView = wordCollectionView
    }
    
    func setUpWordCV(){
        
      
        
        // Set up delegation
        wordCollectionView.delegate = contextCollectionView
        wordCollectionView.dataSource = wordCollectionView
        //wordCollectionView.parentCollectionView = contextCollectionView
    }
    
    
    func passDataToCollectionView <T: PicTalkCollectionView>(source:PicTable, field:String,collectionView: T ){
        if let contextItems = source[field]{
            
            //database
            collectionView.picDatabase = categorizedData
            
            //initial items
            collectionView.dataItems = contextItems
            
            // asseign itself to be data source
            collectionView.dataSource = collectionView
            print(collectionView.dataItems)
        }
        
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

        return cell
    }
    
    var mainCategoryIsSelected = true
    var selectedMainContext = ""
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
      
        
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)!
        print("didSelectItemAtIndexPath")
        switch collectionView.tag {
    
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
