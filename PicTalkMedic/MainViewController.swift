//
//  ViewController.swift
//  PicTalkMedic
//
//  Created by Pak on 29/08/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, AVSpeechSynthesizerDelegate  {
    
    
    //MARK: Outlets
    
    //Text
    @IBOutlet weak var messageDisplay: UILabel!
    
    //Buttons
    @IBOutlet weak var speakButton: UIButton!
//    @IBAction func utterMessage(sender: UIButton) {
//        let text = getMessageText()
//        utter(text)
//    }
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
    

    var selectedSub = 0

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
        
        synthesizer.delegate = self
        
        setUpSelectionView(contextCollectionView, childCV: wordCollectionView)
        setUpMessageCollectionView()
        
    }
    
   
  
    
    // MARK: Stay here
    
    func setUpMessageCollectionView(){
        messageCollectionView.delegate = messageCollectionView
        messageCollectionView.dataSource = messageCollectionView
    }
    
    
    func passDataToCollectionView <T: PicTalkCollectionView>(source:PicTable, field:String,collectionView: T ){
        if let contextItems = source[field]{
            
            //database
            collectionView.picDatabase = categorizedData
            //initial items
            collectionView.dataItems = contextItems
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var mainCategoryIsSelected = true
    var selectedMainContext = ""

    
    //    MARK: Utterance & Synthesizer
    let synthesizer = AVSpeechSynthesizer()
    var utteranceQueue = [NSIndexPath]()
//    
//    func getMessageText() -> String{
//        let dataItems = data[messageCollectionView.tag].dataItems
//        var text = ""
//        for d in dataItems {
//            text += d.swedish + "      "
//        }
//        return text
//    }
//    
//    func updateMessageDisplay(){
//        messageDisplay.text = getMessageText()
//    }
//    
//    func utter(text:String){
//        //action
//        let utter = AVSpeechUtterance(string: text)
//        utter.voice = AVSpeechSynthesisVoice(language: selectedLang)
//        synthesizer.speakUtterance(utter)
//        
//    }
//    
//    
//    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
//        
//        if let item = utteranceQueue.first{
//            contextCollectionView.cellForItemAtIndexPath(item)?.alpha = 1
//            utteranceQueue.removeFirst()
//            
//        }
//        
//    }
    
    
}


extension MainViewController{
    
    // MARK: Selection View
    
    func setUpSelectionView(parentCV:ContextCollectionView, childCV:WordCollectionView){
        func setUpContextCV(parentCollectionView: ContextCollectionView, childCollectionView:WordCollectionView){
            passDataToCollectionView(categorizedData, field: "context", collectionView: parentCollectionView)
            parentCollectionView.delegate = parentCollectionView
            parentCollectionView.dataSource = parentCollectionView
            parentCollectionView.childCollectionView = childCollectionView
        }
        
        func setUpWordCV(childCollectionView:WordCollectionView){
            childCollectionView.delegate = wordCollectionView
            childCollectionView.dataSource = childCollectionView
            childCollectionView.messageView = messageCollectionView
        }
        setUpContextCV(parentCV,childCollectionView: childCV)
        setUpWordCV(childCV)
    }
}
