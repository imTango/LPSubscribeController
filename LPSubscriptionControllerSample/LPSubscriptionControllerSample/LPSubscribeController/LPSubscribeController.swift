//
//  LPSubscribeController.swift
//  LPSubscriptionControllerSample
//
//  Created by litt1e-p on 16/7/15.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

import UIKit

class LPSubscribeController: UIViewController
{
    internal var selectedArray: [String]? = [String]()
    internal var optionalArray: [String]? = [String]()
    private var cellAttributesArray: [UICollectionViewLayoutAttributes]? = [UICollectionViewLayoutAttributes]()
    private var isSort: Bool = false
    private var lastIsHidden: Bool = false
    
    convenience init (selectedArr: [String]?, optionalArr: [String]?) {
        self.init()
        selectedArray = selectedArr
        optionalArray = optionalArr
        cellAttributesArray = [UICollectionViewLayoutAttributes]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.registerClass(LPSubscribeCell.self, forCellWithReuseIdentifier: String(LPSubscribeCell))
        collectionView.registerClass(LPSubscribeHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kLPSCSectionHeaderOneIdentifier)
        collectionView.registerClass(LPSubscribeHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kLPSCSectionHeaderTwoIdentifier)
    }
    
    private lazy var animationLabel: UILabel = {
        let al = UILabel()
        al.textAlignment             = .Center
        al.font                      = UIFont.systemFontOfSize(15.0)
        al.numberOfLines             = 1
//        al.adjustsFontSizeToFitWidth = true
//        al.minimumScaleFactor        = 0.1
        al.textColor                 = RGBA(101, 101, 101, 1)
        al.layer.masksToBounds       = true
        al.layer.borderColor         = RGBA(211, 211, 211, 1).CGColor
        al.layer.borderWidth         = 0.45
        return al
    } ()
    
    private lazy var collectionView: UICollectionView = {
        let layout              = LPSubscribeLayout()
//        let layout              = LPSubscribeLeftAlignLayout()
        let cv                  = UICollectionView(frame: CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 64), collectionViewLayout: layout)
        cv.backgroundColor      = .whiteColor()
        cv.alwaysBounceVertical = true
        cv.delegate             = self
        cv.dataSource           = self
        return cv
    } ()
    
    @objc private func sortItem(pan: UIPanGestureRecognizer) {
        let cell = pan.view as! LPSubscribeCell
        let cellIndexPath = collectionView.indexPathForCell(cell)
        if pan.state == .Began {
            cellAttributesArray?.removeAll()
            if selectedArray?.count > 0 {
                for i in 0 ..< selectedArray!.count {
                    cellAttributesArray?.append(collectionView.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0))!)
                }
            }
        }
        let point = pan.translationInView(collectionView)
        cell.center = CGPointMake(cell.center.x + point.x, cell.center.y + point.y)
        pan.setTranslation(CGPointMake(0, 0), inView: collectionView)
        
        var isChange = false
        for attr in cellAttributesArray! {
            let rect = CGRectMake(attr.center.x - 6, attr.center.y - 6, 12, 12)
            if CGRectContainsPoint(rect, CGPointMake(pan.view!.center.x, pan.view!.center.y)) && cellIndexPath != attr.indexPath {
                if cellIndexPath?.item > attr.indexPath.item {
                    for index in (cellIndexPath?.item)!.stride(to: attr.indexPath.item, by: -1) {
                        exchange(&selectedArray!, i: index, j: index - 1)
                    }
                } else {
                    for index in cellIndexPath!.item ..< attr.indexPath.item {
                        exchange(&selectedArray!, i: index, j: index + 1)
                    }
                }
                isChange = true
                collectionView.moveItemAtIndexPath(cellIndexPath!, toIndexPath: attr.indexPath)
            } else {
                isChange = false
            }
        }
        if pan.state == .Ended {
            if !isChange {
                cell.center = collectionView.layoutAttributesForItemAtIndexPath(cellIndexPath!)!.center
            }
            resetIndexPath()
        }
    }
    
    private func resetIndexPath() {
        guard selectedArray?.count > 0 else {return}
        for i in 0 ..< selectedArray!.count {
            let newIndexPath = NSIndexPath(forItem: i, inSection: 0)
            let cell = collectionView.cellForItemAtIndexPath(newIndexPath) as! LPSubscribeCell
            cell.indexPath = newIndexPath
        }
    }
}

// MARK: - UICollectionViewItemSizeLayoutDelegate

extension LPSubscribeController: UICollectionViewItemSizeLayoutDelegate
{
    typealias IsLimitWidth = ((isLimit: Bool, data: AnyObject)->Void)?
    
    private func cellWidth(text: String?) -> CGFloat {
        var w: CGFloat = 0.0
        guard text?.characters.count > 0 else {return w}
        let str = text! as NSString
        let s   = str.sizeWithAttributes([NSFontAttributeName : UIFont.systemFontOfSize(14.0)])
        w       = CGFloat(ceilf(Float(s.width))) + 12
        return min(w, CGRectGetWidth(collectionView.frame))
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var s = CGSizeZero
        let text = indexPath.section == 0 ? selectedArray![indexPath.row] : optionalArray![indexPath.row]
        s   = CGSizeMake(cellWidth(text), 40)
        return s
    }
}

extension LPSubscribeController: LPSubscribeCellDeleteDelegate
{
    func deleteItem(indexPath: NSIndexPath) {
        optionalArray?.insert(selectedArray![indexPath.item], atIndex: 0)
        selectedArray?.removeAtIndex(indexPath.item)
        collectionView.deleteItemsAtIndexPaths([indexPath])
        resetIndexPath()
    }
}

extension LPSubscribeController: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            lastIsHidden = true
            let endCell = collectionView.cellForItemAtIndexPath(indexPath) as! LPSubscribeCell
            endCell.contentLabel.hidden = true
            selectedArray?.append(optionalArray![indexPath.item])
            UIView.animateWithDuration(0, animations: {
                [weak self] in
                self!.collectionView.performBatchUpdates({ 
                    self?.collectionView.reloadSections(NSIndexSet(index: 0))
                    }, completion: nil)
            })
            
            let startAttr = collectionView.layoutAttributesForItemAtIndexPath(indexPath)
            animationLabel.frame = (startAttr?.frame)!
            animationLabel.layer.cornerRadius = CGRectGetHeight(animationLabel.bounds) * 0.5
            animationLabel.text = optionalArray![indexPath.item]
            collectionView.addSubview(animationLabel)
            
            let toIndexPath = NSIndexPath(forItem: (selectedArray?.count)! - 1, inSection: 0)
            let endAttr = collectionView.layoutAttributesForItemAtIndexPath(toIndexPath)
            UIView.animateWithDuration(kLPSCAddAnimationDuration, animations: {
                [weak self] in
                self!.animationLabel.center = (endAttr?.center)!
                }, completion: { [weak self] (finished: Bool) in
                    let endCell = self!.collectionView.cellForItemAtIndexPath(toIndexPath) as! LPSubscribeCell
                    endCell.contentLabel.hidden = false
                    self!.lastIsHidden = false
                    self!.animationLabel.removeFromSuperview()
                    self!.optionalArray?.removeAtIndex(indexPath.item)
                    self!.collectionView.deleteItemsAtIndexPaths([indexPath])
                })
        }
    }
}

extension LPSubscribeController: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(LPSubscribeCell), forIndexPath: indexPath) as! LPSubscribeCell
        if indexPath.section == 0 {
            cell.configCell(selectedArray!, indexPath: indexPath)
            if indexPath.item == 0 {
                cell.deleteButton.hidden = true
            } else {
                cell.delegate = self
                cell.deleteButton.hidden = !isSort
                if isSort {
                    cell.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.sortItem(_:))))
                }
                if selectedArray?.count > 0 && indexPath.item == selectedArray!.count - 1 {
                    cell.contentLabel.hidden = lastIsHidden
                }
            }
        } else {
            if optionalArray?.count > 0 {
                cell.configCell(optionalArray!, indexPath: indexPath)
            }
            cell.deleteButton.hidden = true
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView: LPSubscribeHeader
        if indexPath.section == 0 {
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kLPSCSectionHeaderOneIdentifier, forIndexPath: indexPath) as! LPSubscribeHeader
            reusableView.buttonHidden = false
            reusableView.clickButton.selected = isSort
            reusableView.backgroundColor = .whiteColor()
            reusableView.clickBlock = {
                [weak self] (state) in
                if state == .Editing {
                    self!.isSort = true
                } else {
                    self!.isSort = false
                    if self!.cellAttributesArray?.count > 0 {
                        for attr in self!.cellAttributesArray! {
                            guard self!.collectionView.numberOfItemsInSection(0) > attr.indexPath.item else {continue}
                            let cell = self!.collectionView.cellForItemAtIndexPath(attr.indexPath) as! LPSubscribeCell
                            if cell.gestureRecognizers?.count > 0 {
                                for ges in cell.gestureRecognizers! {
                                    cell.removeGestureRecognizer(ges)
                                }
                            }
                        }
                    }
                }
                self!.collectionView.reloadData()
            }
            reusableView.titleLabel.text = kLPSCDidSelectedDesc
        } else {
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kLPSCSectionHeaderTwoIdentifier, forIndexPath: indexPath) as! LPSubscribeHeader
            reusableView.buttonHidden = true
            reusableView.backgroundColor = RGBA(240, 240, 240, 1)
            reusableView.titleLabel.text = kLPSCAddMoreDesc
        }
        return reusableView
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return isSort ? 1 : 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return selectedArray?.count > 0 ? selectedArray!.count : 0
        } else {
            return optionalArray?.count > 0 ? optionalArray!.count : 0
        }
    }
}
