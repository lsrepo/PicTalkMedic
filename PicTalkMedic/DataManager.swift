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
            categorizedData = getCategorizedData(dict)
        }
        return categorizedData!
    }
    
    
    
    
    func getCategorizedData(dict:NSArray) ->  PicTable {
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
        print(item)
        //create one data item
        let swedish = item["swedish"] as? String
        let arabic = item["arabic"] as? String
        let picName =  swedish != nil ? swedish!.applyNamingRule()  : ""
        let parent = item["parent"]  as? String
        let child = item["child"] as? String
        
        let dataItem = DataItem(swedish: swedish, arabic: arabic, picName: picName, parent: parent, child: child)
        print("", swedish,picName)
        return dataItem
    }
    

}

extension String {
    
    var removePunctuations: String{
        get{
            return self.componentsSeparatedByCharactersInSet(.punctuationCharacterSet()).joinWithSeparator("")
        }
    }
    
    
    var replaceBlankSpace:String{
        get{
            return self.stringByReplacingOccurrencesOfString(" ", withString: "-")
        }
    }
    
    var replaceSwedish:String{
        get{
            var result = self
            result = result.stringByReplacingOccurrencesOfString("å", withString: "ao")
            result = result.stringByReplacingOccurrencesOfString("ö", withString: "oe")
            result = result.stringByReplacingOccurrencesOfString("ä", withString: "ae")
            return result
        }
    }
    
    func applyNamingRule()->String{
        return self.removePunctuations.replaceBlankSpace.replaceSwedish.lowercaseString
    }
}
