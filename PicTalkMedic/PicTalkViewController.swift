//
//  PicTalkViewController.swift
//  PicTalkMedic
//
//  Created by Pak on 07/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit

class PicTalkViewController: UIViewController {
    
    
    @IBOutlet weak var messageColelctionView: MessageColelctionView!
    
    var mainVC:MainViewController = MainViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier{
            switch  identifier {
                //Run when the app launche
            case "ToSelectionViewLeft":
                if let targetVC  = segue.destinationViewController as? MainViewController{
                    mainVC = targetVC
                    
                    mainVC.messageCollectionView = messageColelctionView
                    messageColelctionView.dataSource = mainVC
                    messageColelctionView.delegate = mainVC
                }
               
            default:
                break;
            }
        }
       
        
        //ToSelectionViewLeft)
    }

}
