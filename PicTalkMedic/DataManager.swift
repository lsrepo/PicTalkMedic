//
//  DataManager.swift
//  PicTalkMedic
//
//  Created by Pak on 04/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import Foundation




typealias PicTable = [String:[DataItem]]

typealias DataArray = [[String:AnyObject]]
class DataManager{
    
    
    
    
    func importData(_ fileName:String) ->PicTable{
        
        var categorizedData:PicTable?
        
        var myDict: DataArray?
        if let path = Bundle.main.path(forResource: fileName, ofType: "plist") {
            //myDict = NSDictionary(contentsOfFile: path)
            myDict = NSArray(contentsOfFile:path) as! DataArray
        }
        if let dict = myDict {
            //Get all elements from a category
            categorizedData = getCategorizedData(dict)
        }
        return categorizedData!
    }
    
    
    
    
    func getCategorizedData(_ dict:DataArray) ->  PicTable {
        var categorizedDataItems = [String:[DataItem]]()
        
        for item in dict{
            if let parent = item["parent"] as? String{
                
                // Check if there's such parent
                let newItem = parseOneDataItem(item as AnyObject)
                
                //add items to categorizedDataItems
                if let a  = categorizedDataItems.index(forKey: parent){
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
    
    func parseOneDataItem(_ item:AnyObject)  -> DataItem{
        //print(item)
        //create one data item
        let swedish = item["swedish"] as? String
        let arabic = item["arabic"] as? String
        let arabicFemale = item["arabic-female"] as? String
        let picName =  swedish != nil ? swedish!.applyNamingRule()  : ""
        let parent = item["parent"]  as? String
        let child = item["child"] as? String
        
        let dataItem = DataItem(swedish: swedish, arabic: arabic,arabicFemale:arabicFemale, picName: picName, parent: parent, child: child)
        //print("", swedish,picName)
        return dataItem
    }
    

}

extension String {
    
    ///replace punctuation
    var removePunctuations: String{
        get{
            return self.components(separatedBy: .punctuationCharacters).joined(separator: "")
        }
    }
    
    
    var replaceBlankSpace:String{
        get{
            return self.replacingOccurrences(of: " ", with: "-")
        }
    }
    
    var replaceSwedish:String{
        get{
            var result = self
            result = result.replacingOccurrences(of: "å", with: "ao")
            result = result.replacingOccurrences(of: "ö", with: "oe")
            result = result.replacingOccurrences(of: "ä", with: "ae")
            return result
        }
    }
    
    func applyNamingRule()->String{
        return self.removePunctuations.replaceBlankSpace.replaceSwedish.lowercased()
    }
}
