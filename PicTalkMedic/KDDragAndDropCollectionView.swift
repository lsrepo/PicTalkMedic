//
//  KDDragAndDropCollectionView.swift
//  KDDragAndDropCollectionViews
//
//  Created by Michael Michailidis on 10/04/2015.
//  Copyright (c) 2015 Karmadust. All rights reserved.
//

import UIKit



@objc protocol KDDragAndDropCollectionViewDataSource : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> NSIndexPath?
    func collectionView(collectionView: UICollectionView, dataItemForIndexPath indexPath: NSIndexPath) -> AnyObject
    
    func collectionView(collectionView: UICollectionView, moveDataItemFromIndexPath from: NSIndexPath, toIndexPath to : NSIndexPath) -> Void
    func collectionView(collectionView: UICollectionView, insertDataItem dataItem : AnyObject, atIndexPath indexPath: NSIndexPath) -> Void
    func collectionView(collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath: NSIndexPath) -> Void
    
}

class KDDragAndDropCollectionView: UICollectionView, KDDraggable, KDDroppable {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var draggingPathOfCellBeingDragged : NSIndexPath?
    
    var iDataSource : UICollectionViewDataSource?
    var iDelegate : UICollectionViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    
    }
    

    // MARK : KDDraggable
    func canDragAtPoint(point : CGPoint) -> Bool {
        
        guard let _ = self.dataSource as? KDDragAndDropCollectionViewDataSource else {
            return false
        }
        
        return self.indexPathForItemAtPoint(point) != nil
    }
    
    func representationImageAtPoint(point : CGPoint) -> UIView? {
        
        var imageView : UIView?
        
        if let indexPath = self.indexPathForItemAtPoint(point) {
            
			if let cell = self.cellForItemAtIndexPath(indexPath) {
				UIGraphicsBeginImageContextWithOptions(cell.bounds.size, cell.opaque, 0)
				cell.layer.renderInContext(UIGraphicsGetCurrentContext()!)
				let img = UIGraphicsGetImageFromCurrentImageContext()
				UIGraphicsEndImageContext()
				
				imageView = UIImageView(image: img)
				
				imageView?.frame = cell.frame
			}
        }
        
        return imageView
    }
    
    func dataItemAtPoint(point : CGPoint) -> AnyObject? {
        
        var dataItem : AnyObject?
        
        if let indexPath = self.indexPathForItemAtPoint(point) {
            
            if let dragDropDS : KDDragAndDropCollectionViewDataSource = self.dataSource as? KDDragAndDropCollectionViewDataSource {
                
                dataItem = dragDropDS.collectionView(self, dataItemForIndexPath: indexPath)
                
            }
            
        }
        return dataItem
    }
    
    
    
    func startDraggingAtPoint(point : CGPoint) -> Void {
        
        self.draggingPathOfCellBeingDragged = self.indexPathForItemAtPoint(point)
        
        self.reloadData()
        
    }
    
    func stopDragging() -> Void {
        
        if let idx = self.draggingPathOfCellBeingDragged {
            if let cell = self.cellForItemAtIndexPath(idx) {
                cell.hidden = false
            }
        }
        
        self.draggingPathOfCellBeingDragged = nil
        
        self.reloadData()
        
    }
    
    func dragDataItem(item : AnyObject) -> Void {
        
        if let dragDropDataSource = self.dataSource as? KDDragAndDropCollectionViewDataSource {
            
            if let existngIndexPath = dragDropDataSource.collectionView(self, indexPathForDataItem: item) {
                
                dragDropDataSource.collectionView(self, deleteDataItemAtIndexPath: existngIndexPath)
                
                self.animating = true
                
                self.performBatchUpdates({ () -> Void in
                    
                    self.deleteItemsAtIndexPaths([existngIndexPath])
                    
                    }, completion: { complete -> Void in
                        
                        self.animating = false
                        
                        self.reloadData()
                        
                        
                })
                
                
            }
            
        }
        
    }
    
    // MARK : KDDroppable

    func canDropAtRect(rect : CGRect) -> Bool {
        
        return (self.indexPathForCellOverlappingRect(rect) != nil)
    }
    
    func indexPathForCellOverlappingRect( rect : CGRect) -> NSIndexPath? {
        
        var overlappingArea : CGFloat = 0.0
        var cellCandidate : UICollectionViewCell?
        

        let visibleCells = self.visibleCells()
        if visibleCells.count == 0 {
            return NSIndexPath(forRow: 0, inSection: 0)
        }
        
        if  isHorizontal && rect.origin.x > self.contentSize.width ||
            !isHorizontal && rect.origin.y > self.contentSize.height {
                
            return NSIndexPath(forRow: visibleCells.count - 1, inSection: 0)
        }
        
        
        for visible in visibleCells {
            
            let intersection = CGRectIntersection(visible.frame, rect)
            
            if (intersection.width * intersection.height) > overlappingArea {
                
                overlappingArea = intersection.width * intersection.width
                
                cellCandidate = visible
            }
            
        }
        
        if let cellRetrieved = cellCandidate {
            
            return self.indexPathForCell(cellRetrieved)
        }
        
        return nil
    }
    
    
    private var currentInRect : CGRect?
    func willMoveItem(item : AnyObject, inRect rect : CGRect) -> Void {
        
        let dragDropDataSource = self.dataSource as! KDDragAndDropCollectionViewDataSource // its guaranteed to have a data source
        
        if let _ = dragDropDataSource.collectionView(self, indexPathForDataItem: item) { // if data item exists
            return
        }
        
        if let indexPath = self.indexPathForCellOverlappingRect(rect) {
 
        
            
            dragDropDataSource.collectionView(self, insertDataItem: item, atIndexPath: indexPath)
            
            self.draggingPathOfCellBeingDragged = indexPath
            
            self.animating = true
            
            self.performBatchUpdates({ () -> Void in
                
                    self.insertItemsAtIndexPaths([indexPath])
                
                }, completion: { complete -> Void in
                    
                    self.animating = false
                    
                    // if in the meantime we have let go
                    if self.draggingPathOfCellBeingDragged == nil {
                      
                        self.reloadData()
                    }
                    
                    
                })
            
            
        }
        
        currentInRect = rect
        
    }
    
    var isHorizontal : Bool {
        return (self.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection == .Horizontal
    }
    
    var animating: Bool = false
    
    var paging : Bool = false
    func checkForEdgesAndScroll(rect : CGRect) -> Void {
        
        if paging == true {
            return
        }
        
        let currentRect : CGRect = CGRect(x: self.contentOffset.x, y: self.contentOffset.y, width: self.bounds.size.width, height: self.bounds.size.height)
        var rectForNextScroll : CGRect = currentRect
        
        if isHorizontal {
            
            let leftBoundary = CGRect(x: -30.0, y: 0.0, width: 30.0, height: self.frame.size.height)
            let rightBoundary = CGRect(x: self.frame.size.width, y: 0.0, width: 30.0, height: self.frame.size.height)
            
            if CGRectIntersectsRect(rect, leftBoundary) == true {
                rectForNextScroll.origin.x -= self.bounds.size.width * 0.5
                if rectForNextScroll.origin.x < 0 {
                    rectForNextScroll.origin.x = 0
                }
            }
            else if CGRectIntersectsRect(rect, rightBoundary) == true {
                rectForNextScroll.origin.x += self.bounds.size.width * 0.5
                if rectForNextScroll.origin.x > self.contentSize.width - self.bounds.size.width {
                    rectForNextScroll.origin.x = self.contentSize.width - self.bounds.size.width
                }
            }
            
        } else { // is vertical
            
            let topBoundary = CGRect(x: 0.0, y: -30.0, width: self.frame.size.width, height: 30.0)
            let bottomBoundary = CGRect(x: 0.0, y: self.frame.size.height, width: self.frame.size.width, height: 30.0)
            
            if CGRectIntersectsRect(rect, topBoundary) == true {
                
            }
            else if CGRectIntersectsRect(rect, bottomBoundary) == true {
                
            }
        }
        
        // check to see if a change in rectForNextScroll has been made
        if CGRectEqualToRect(currentRect, rectForNextScroll) == false {
            self.paging = true
            self.scrollRectToVisible(rectForNextScroll, animated: true)
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.paging = false
            }
            
        }
        
    }
    
    func didMoveItem(item : AnyObject, inRect rect : CGRect) -> Void {
        
        let dragDropDS = self.dataSource as! KDDragAndDropCollectionViewDataSource // guaranteed to have a ds
        
        if  let existingIndexPath = dragDropDS.collectionView(self, indexPathForDataItem: item),
            let indexPath = self.indexPathForCellOverlappingRect(rect) {
   
                if indexPath.item != existingIndexPath.item {
                    
                    dragDropDS.collectionView(self, moveDataItemFromIndexPath: existingIndexPath, toIndexPath: indexPath)
                    
                    self.animating = true
                    
                    self.performBatchUpdates({ () -> Void in
                        
                            self.moveItemAtIndexPath(existingIndexPath, toIndexPath: indexPath)
                        
                        }, completion: { (finished) -> Void in
                            
                            self.animating = false
                            
                            self.reloadData()
                            
                        })
                    
                    self.draggingPathOfCellBeingDragged = indexPath
                    
                }
        }
        
        // Check Paging
        
        var normalizedRect = rect
        normalizedRect.origin.x -= self.contentOffset.x
        normalizedRect.origin.y -= self.contentOffset.y
        
        currentInRect = normalizedRect
        
        
        self.checkForEdgesAndScroll(normalizedRect)
        
        
    }
    
    func didMoveOutItem(item : AnyObject) -> Void {
        
        guard let dragDropDataSource = self.dataSource as? KDDragAndDropCollectionViewDataSource,
              let existngIndexPath = dragDropDataSource.collectionView(self, indexPathForDataItem: item) else {
            
            return
        }
        
        dragDropDataSource.collectionView(self, deleteDataItemAtIndexPath: existngIndexPath)
        
        self.animating = true
        
        self.performBatchUpdates({ () -> Void in
            
            self.deleteItemsAtIndexPaths([existngIndexPath])
            
            }, completion: { (finished) -> Void in
                
                self.animating = false;
                
                self.reloadData()
                
            })
        
        
        if let idx = self.draggingPathOfCellBeingDragged {
            if let cell = self.cellForItemAtIndexPath(idx) {
                cell.hidden = false
            }
        }
        
        self.draggingPathOfCellBeingDragged = nil
        
        currentInRect = nil
    }
    
    
    func dropDataItem(item : AnyObject, atRect : CGRect) -> Void {
        
        // show hidden cell
        if  let index = draggingPathOfCellBeingDragged,
            let cell = self.cellForItemAtIndexPath(index) where cell.hidden == true {
            
            cell.alpha = 1.0
            cell.hidden = false
            
            
            
        }
    
        currentInRect = nil
        
        self.draggingPathOfCellBeingDragged = nil
        
        self.reloadData()
        
    }
    
    
}
