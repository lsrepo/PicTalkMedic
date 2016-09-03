//
//  WordCollectionView.swift
//  PicTalkMedic
//
//  Created by Pak on 03/09/16.
//  Copyright © 2016 pictalk.se. All rights reserved.
//

import UIKit

class WordCollectionView: KDDragAndDropCollectionView {

    var dataItems:[DataItem] = {
        var dataItem = [DataItem]()
        dataItem.append( DataItem(swedish: "cash", arabic: "arr1", picName: "cash") )
        dataItem.append( DataItem(swedish: "bill", arabic: "arr2", picName: "bill") )
        dataItem.append( DataItem(swedish: "credit card", arabic: "arr3", picName: "credit_card") )
        dataItem.append( DataItem(swedish: "receipt", arabic: "arr4", picName: "receipt") )
        
        return dataItem
    }()
    
    //[["Red","Blue","Yellow"],["Greet","Intend","Identify","Pay"]]
    
}
