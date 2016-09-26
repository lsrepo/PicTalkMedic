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
    
   
    @IBAction func switchSpeakerButtonTapped(_ sender: UIButton) {
 
        //switch bubble
        if (bubbleImageView.tag == -1){
            switchLanguage(language: .swedish)
            speakerAButton.alpha = 0.5
            speakerBButton.alpha = 1.0
            
            
            bubbleImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            bubbleImageView.tag = 1
        }else{
            switchLanguage(language: .arabic)
            speakerAButton.alpha = 1.0
            speakerBButton.alpha = 0.5
            
            bubbleImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
            bubbleImageView.tag = -1
        }
    }
    @IBOutlet weak var speakerAButton: SpeakerButton!
    @IBOutlet weak var speakerAButtonTapped: SpeakerButton!
    @IBAction func speakerBButtonTapped(_ sender: SpeakerButton) {
 
    }
    @IBOutlet weak var speakerBButton: SpeakerButton!
    
// MARK: Switch Language
    
    func switchLanguage(language:Language){
        sharedParams.selectedLang = language
        reloadAllCollectionViews()
        
        //reload message display
        updateMessageDisplay(getTextOfMessage(lang:sharedParams.selectedLang))
        
        //reset questionMarkButton title
        switchQuestionMarkButtonTitle()
    }
    
    func switchQuestionMarkButtonTitle(){
        
        if (questionMarkBtn.titleLabel?.text! == "?"){
            questionMarkBtn.setTitle("⸮", for: .normal)
        }else{
              questionMarkBtn.setTitle("?", for: .normal)
        }
    }
    
    
    
    @IBOutlet weak var bubbleImageView: UIImageView!
    
    //MARK: Outlets
    @IBOutlet weak var questionMarkBtn: UIButton!
    
    @IBAction func questionMarkBtnTapped(_ sender: UIButton) {
        //messageCollectionView.isQuestion = !messageCollectionView.isQuestion
        if messageCollectionView.isQuestion{
            deactivateQuestionMode()
        }else{
            activateQuestionMode()
        }
        //messageCollectionView.reloadData()
        
    }
    
    func activateQuestionMode(){
        messageCollectionView.isQuestion = true
        
        questionMarkBtn.layer.borderWidth = 2
        questionMarkBtn.layer.cornerRadius = 15
        questionMarkBtn.layer.borderColor = Style.primaryColor.cgColor
        questionMarkBtn.layer.backgroundColor = Style.primaryColor.cgColor
        questionMarkBtn.setTitleColor(UIColor.white, for: .normal)
        
        messageCollectionView.reloadData()
    }
    
    func deactivateQuestionMode(){
        messageCollectionView.isQuestion = false
        
        questionMarkBtn.layer.borderWidth = 0
        questionMarkBtn.setTitleColor(UIColor.black, for: .normal)
        questionMarkBtn.layer.backgroundColor = UIColor.clear.cgColor
        
        messageCollectionView.reloadData()
    }
    
    
    @IBAction func clearMessage(_ sender: UIButton) {
        messageCollectionView.dataItems.removeAll()
        messageCollectionView.reloadData()
        //update ui
        messageDisplay.text = ""
        
        // deactivate question mode
        if messageCollectionView.isQuestion{
            deactivateQuestionMode()
        }
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
//        let cells = wordCollectionView.visibleCells
//        for cell in cells{
//            if let castedCell = cell as? WordCollectionViewCell{
//                castedCell.switchGender()
//            }
//        }

        
 
        
    }
    @IBAction func switchLang(_ sender: UIButton) {
        
        //TO-DO: add target language
        //previosu selected language
        
        switch sharedParams.selectedLang{
        case .arabic:
            sharedParams.selectedLang = .swedish

        case .swedish:
            sharedParams.selectedLang = .arabic
        default:
            break
        }
        reloadAllCollectionViews()

        //reload message display
        updateMessageDisplay(getTextOfMessage(lang:sharedParams.selectedLang))
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
    
    override func viewWillAppear(_ animated: Bool) {
        // set-up initial appearance
        speakerAButton.alpha = 0.5
    }
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
    
    
    func getTextOfMessage(lang:Language)->String{
        return messageCollectionView.getMessageText(lang:lang)
    }
    
    func utter(){
        
        //prepare text 
        var text = ""

        // default
        var utterLang = Language.arabic.rawValue
        
        switch sharedParams.selectedLang{
        case .arabic:
            text = getTextOfMessage(lang:Language.swedish)
            utterLang = Language.swedish.rawValue
            
        case .swedish:
            text = getTextOfMessage(lang:Language.arabic)
            utterLang = Language.arabic.rawValue
        default:
            break
        }
        
        
        //action
        let utter = AVSpeechUtterance(string: text)
        utter.voice = AVSpeechSynthesisVoice(language: utterLang)
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
    
    func deactivateQuestionMode()
    
}
