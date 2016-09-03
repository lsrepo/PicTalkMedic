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
        dataItem.append( DataItem(swedish: "left", arabic: "arr1", picName: "waiting_room") )
        dataItem.append( DataItem(swedish: "elevator", arabic: "arr2", picName: "elevator") )
        
        return dataItem
    }()
    
    //[["Red","Blue","Yellow"],["Greet","Intend","Identify","Pay"]]
   
    
    

    

}