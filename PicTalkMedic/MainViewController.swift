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
    
    //MARK: Collection Views
    @IBOutlet weak var messageCollectionView: MessageColelctionView!
    
    // ON THE Left
    @IBOutlet weak var contextCollectionView: ContextCollectionView!
    @IBOutlet weak var wordCollectionView: WordCollectionView!
    
    // ON THE Right
    @IBOutlet weak var quickCategoryCollectionView: QuickCategoryCollectionView!
    @IBOutlet weak var quickWordCollectionView: WordCollectionView!
    
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // message view
        setUpMessageCollectionView()
        
        // set up right hand side
        quickCategoryCollectionView.grandParent = "sys_quick"
        print(quickCategoryCollectionView.grandParent)
        
        // set up the two selection views
        setUpSelectionView(contextCollectionView, childCV: wordCollectionView,grandParent: "context")
        setUpSelectionView(quickCategoryCollectionView, childCV: quickWordCollectionView,grandParent: "sys_quick")
        
        //Synthesizer
        synthesizer.delegate = self
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
    
    func getMessageText() -> String{
        let dataItems = messageCollectionView.dataItems
        var text = ""
        for d in dataItems {
            text += d.swedish + "      "
        }
        print("textdataItems",dataItems)
        print(text)
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
       print("finsih speaking")
    }
    
    
}


extension MainViewController{
    
    // MARK: Selection View
    
    func setUpSelectionView(parentCV:ContextCollectionView, childCV:WordCollectionView,grandParent:String){
        func setUpContextCV(parentCollectionView: ContextCollectionView, childCollectionView:WordCollectionView){
            passDataToCollectionView(categorizedData, field: grandParent, collectionView: parentCollectionView)
            parentCollectionView.delegate = parentCollectionView
            parentCollectionView.dataSource = parentCollectionView
            parentCollectionView.childCollectionView = childCollectionView
        }
        
        func setUpWordCV(childCollectionView:WordCollectionView){
            childCollectionView.delegate = childCollectionView
            childCollectionView.dataSource = childCollectionView
            childCollectionView.messageView = messageCollectionView
        }
        setUpContextCV(parentCV,childCollectionView: childCV)
        setUpWordCV(childCV)
    }
}
