//
//  DataManager.swift
//  PicTalkMedic
//
//  Created by Pak on 04/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import Foundation




typealias PicTable = [String:[DataItem]]

class DataManager{
    
    
    
    
    func importData(fileName:String) ->PicTable{
        
        var categorizedData:PicTable?
        
        var myDict: NSArray?
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "plist") {
            //myDict = NSDictionary(contentsOfFile: path)
            myDict = NSArray(contentsOfFile:path)
        }
        if let dict = myDict {
            //Get all elements from a category
            categorizedData = getCategorizedData("reception", dict: dict)
        }
        return categorizedData!
    }
    
    
    
    
    func getCategorizedData(categoryName:String, dict:NSArray) ->  PicTable {
        var categorizedDataItems = [String:[DataItem]]()
        
        for item in dict{
            if let parent = item["parent"] as? String{
                
                // Check if there's such parent
                let newItem = parseOneDataItem(item)
                
                //add items to categorizedDataItems
                if let a  = categorizedDataItems.indexForKey(parent){
                    // the pair already exists
                    // get the old value
                    var array = categorizedDataItems[a].1
                    
                    array.append(newItem)
                    categorizedDataItems.updateValue(array, forKey: parent)
                   
                }else{
                    // the pair did not exist
                    categorizedDataItems.updateValue([newItem], forKey: parent)
                    
                    
                }
                
            }
        }
        return (categorizedDataItems)
    }
    
    func parseOneDataItem(item:AnyObject)  -> DataItem{
        //create one data item
        let swedish = item["swedish"] as! String
        let arabic = item["arabic"] as! String
        let english = item["english"]  as! String
        let parent = item["parent"]  as! String
        let contain = item["contain"] as? String
        
        let dataItem = DataItem(swedish: swedish, arabic: arabic, picName: english, parent: parent, contain: contain)
        return dataItem
    }
    
}
