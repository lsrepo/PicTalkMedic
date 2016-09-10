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
        utter()
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
        switch sharedParams.selectedLang{
        case .arabic:
            sharedParams.selectedLang = .swedish
        case .swedish:
            sharedParams.selectedLang = .arabic
        default:
            break
        }
        
        //reload data
        
        reloadAllCollectionViews()
        
        //reload message display
        messageDisplay.text = getTextOfMessageInSelectedLang()
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
        print(quickCategoryCollectionView.grandParent)
        
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
    
    
    func didSwipe(recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.Ended {
            print("swipe ended")
        }
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
    
    // MARK: Helpers
    
    func reloadAllCollectionViews(){
        for cv in collectionViews{
            cv.reloadData()
        }
    }
    
    // MARK: Utterance & Synthesizer
    let synthesizer = AVSpeechSynthesizer()
    var utteranceQueue = [NSIndexPath]()
    
    func getTextOfMessageInSelectedLang()->String{
        return messageCollectionView.getMessageText()
    }
    
    func utter(){
        
        //prepare text 
        let text = getTextOfMessageInSelectedLang()
        
        //action
        let utter = AVSpeechUtterance(string: text)
        
        let selectedLang = sharedParams.selectedLang.rawValue
        print(selectedLang)
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
        
        parentCV.sharedParams = sharedParams
        childCV.sharedParams = sharedParams
    }
}

extension MainViewController:MessageDataDelegate{
    
    func updateMessageDisplay(message:String){
        messageDisplay.text = message
    }
    
}

protocol  MessageDataDelegate: class {
    
    func updateMessageDisplay(message:String)
    

    
}
