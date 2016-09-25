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
    @IBOutlet weak var questionMarkBtn: UIButton!
    
    @IBAction func questionMarkBtnTapped(_ sender: UIButton) {
        messageCollectionView.isQuestion = !messageCollectionView.isQuestion
        messageCollectionView.reloadData()
        
    }
    @IBAction func clearMessage(_ sender: UIButton) {
        messageCollectionView.dataItems.removeAll()
        messageCollectionView.reloadData()
        //update ui
        messageDisplay.text = ""
    }
    //Text
    @IBOutlet weak var messageDisplay: UILabel!
    
    //Buttons
    @IBOutlet weak var speakButton: UIButton!
    @IBAction func utterMessage(_ sender: UIButton) {
        utter()
    }
    //Buttons Touch Events
    @IBAction func switchGender(_ sender: AnyObject) {
        let cells = wordCollectionView.visibleCells
        for cell in cells{
            if let castedCell = cell as? WordCollectionViewCell{
                castedCell.switchGender()
            }
        }
        
        
        
    }
    @IBAction func switchLang(_ sender: UIButton) {
        
        //TO-DO: add target language
        //previosu selected language
        
        switch sharedParams.selectedLang{
        case .arabic:
            sharedParams.selectedLang = .swedish
            //messageCollectionView.reverseDataItems()
        case .swedish:
            sharedParams.selectedLang = .arabic
            //messageCollectionView.reverseDataItems()
        default:
            break
        }
        reloadAllCollectionViews()
        
        //print("update message display",getTextOfMessageInSelectedLang())
        //reload message display
        
        updateMessageDisplay(getTextOfMessageInSelectedLang())
    }
    
    //MARK: Collection Views
    @IBOutlet weak var messageCollectionView: MessageColelctionView!
    
    // ON THE Left
    @IBOutlet weak var contextCollectionView: ContextCollectionView!
    @IBOutlet weak var wordCollectionView: WordCollectionView!
    
    // ON THE Right
    @IBOutlet weak var quickCategoryCollectionView: QuickCategoryCollectionView!
    @IBOutlet weak var quickWordCollectionView: WordCollectionView!
    
    
    var collectionViews:[PicTalkCollectionView]!
    

    //var selectedSub = 0
    
    let sharedParams = SharedParams()
    
    let categorizedData = DataManager().importData("test")
    

    //Message Area
    var message:[DataItem]  = {
        var dataItem = [DataItem]()
        return dataItem
    }()
    

    // MARK: VidedidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //all views
      collectionViews =  [messageCollectionView,contextCollectionView,wordCollectionView,quickCategoryCollectionView,quickWordCollectionView]
        
        
        // message view
        setUpMessageCollectionView()
        
        // set up right hand side
        quickCategoryCollectionView.grandParent = "Quick"
        //print(quickCategoryCollectionView.grandParent)
        
        // set up the two selection views
        setUpSelectionView(contextCollectionView, childCV: wordCollectionView,grandParent: "context")
        setUpSelectionView(quickCategoryCollectionView, childCV: quickWordCollectionView,grandParent: "Quick")
        
        
        
        
        //Synthesizer
        synthesizer.delegate = self
    }
    
   
  
    
    // MARK: Stay here
    
    func setUpMessageCollectionView(){
        messageCollectionView.delegate = messageCollectionView
        messageCollectionView.dataSource = messageCollectionView
        messageCollectionView.messageDataDelegate = self
        messageCollectionView.sharedParams = sharedParams
        
        // Gesture
    }
    
    
    func didSwipe(_ recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.ended {
            //print("swipe ended")
        }
    }
    
    
    func passDataToCollectionView <T: PicTalkCollectionView>(_ source:PicTable, field:String,collectionView: T ){
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
    
    // MARK: Helpers
    
    func reloadAllCollectionViews(){
        for cv in collectionViews{
            cv.reloadData()
        }
    }
    
    // MARK: Utterance & Synthesizer
    let synthesizer = AVSpeechSynthesizer()
    var utteranceQueue = [IndexPath]()
    
    func getTextOfMessageInSelectedLang()->String{
        return messageCollectionView.getMessageText()
    }
    
    func utter(){
        
        //prepare text 
        let text = getTextOfMessageInSelectedLang()
        
        //action
        let utter = AVSpeechUtterance(string: text)
        
        let selectedLang = sharedParams.selectedLang.rawValue
        //print(selectedLang)
        utter.voice = AVSpeechSynthesisVoice(language: selectedLang)
        synthesizer.speak(utter)
        
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
       //print("finsih speaking")
    }
    
    
}


extension MainViewController{
    
    // MARK: Selection View
    
    func setUpSelectionView(_ parentCV:ContextCollectionView, childCV:WordCollectionView,grandParent:String){
        func setUpContextCV(_ parentCollectionView: ContextCollectionView, childCollectionView:WordCollectionView){
            passDataToCollectionView(categorizedData, field: grandParent, collectionView: parentCollectionView)
            parentCollectionView.delegate = parentCollectionView
            parentCollectionView.dataSource = parentCollectionView
            parentCollectionView.childCollectionView = childCollectionView
            
            
        }
        
        func setUpWordCV(_ childCollectionView:WordCollectionView){
            childCollectionView.delegate = childCollectionView
            childCollectionView.dataSource = childCollectionView
            childCollectionView.messageView = messageCollectionView
        }
        setUpContextCV(parentCV,childCollectionView: childCV)
        setUpWordCV(childCV)
        
        parentCV.sharedParams = sharedParams
        childCV.sharedParams = sharedParams
    }
}

extension MainViewController:MessageDataDelegate{
    
    func updateMessageDisplay(_ message:String){
        messageDisplay.text = message
    }
    
}

protocol  MessageDataDelegate: class {
    
    func updateMessageDisplay(_ message:String)
    

    
}
