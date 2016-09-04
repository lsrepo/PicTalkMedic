//
//  DataManager.swift
//  PicTalkMedic
//
//  Created by Pak on 04/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import Foundation


struct Category{
   static let identify = DataItem(swedish: "identify", arabic: "arr", picName: "identify")
     static let pay = DataItem(swedish: "pay", arabic: "arr", picName: "pay")
    
    static let categories = ["reception","consultation"]
    static let subCategories = ["reception":[identify,pay]]
    
    
}


class DataManager{
    
    
    
    func importData(fileName:String) ->[String:[DataItem]]{
        
        var categorizedData = [String:[DataItem]]()
        var myDict: NSArray?
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "plist") {
            //myDict = NSDictionary(contentsOfFile: path)
            myDict = NSArray(contentsOfFile:path)
        }
        if let dict = myDict {
            //Get all elements from a category
            categorizedData = getCategorizedData("reception", dict: dict)
            
        }
        return categorizedData
    }
    
   
    
    
    func getCategorizedData(categoryName:String, dict:NSArray) ->  [String:[DataItem]] {
        var categorizedDataItems = [String:[DataItem]]()
        for item in dict{
            if let category = item["category"] as? String{
                
                // Check if there's such category
                let newItem = parseOneDataItem(item)
                
                    if let a  = categorizedDataItems.indexForKey(category){
                        // the pair already exists
                        // get the old value
                        var array = categorizedDataItems[a].1
                        
                        array.append(newItem)
                        categorizedDataItems.updateValue(array, forKey: category)
                        print("already exist")
                    }else{
                        // the pair did not exist
                       categorizedDataItems.updateValue([newItem], forKey: category)
                }
            }
        }
        return categorizedDataItems
    }
    
    func parseOneDataItem(item:AnyObject)  -> DataItem{
        //create one data item
        let swedish = item["swedish"] as! String
        let arabic = item["arabic"] as! String
        let english = item["english"]  as! String
        
        let dataItem = DataItem(swedish: swedish, arabic: arabic, picName: english)
        return dataItem
    }

}
