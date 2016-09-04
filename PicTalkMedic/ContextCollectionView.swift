//
//  ContextCollectionView.swift
//  PicTalkMedic
//
//  Created by Pak on 03/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import Foundation
import UIKit

class ContextCollectionView:UICollectionView
{
    
    let dataItems:[DataItem]  = {
        var dataItem = [DataItem]()
        // not likely to change
        dataItem.append( DataItem(swedish: "Waiting Room", arabic: "arr1", picName: "waiting_room") )
        dataItem.append( DataItem(swedish: "reception", arabic: "arr2", picName: "reception") )
        dataItem.append( DataItem(swedish: "Concultation", arabic: "arr2", picName: "reception") )
        
        return dataItem
    }()
    
    //[["Red","Blue","Yellow"],["Greet","Intend","Identify","Pay"]]
   
    
    

    

}