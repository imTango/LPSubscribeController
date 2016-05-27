//
//  LPSubscriptionController.swift
//  LPSubscriptionControllerSample
//
//  Created by litt1e-p on 16/5/26.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

import UIKit


class LPSubscriptionController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    typealias IsLimitWidth = (yesOrNo: Bool, data: AnyObject)
    
    let kSubscriptionCollectionViewCellID          = "kSubscriptionCollectionViewCellID"
    let kSubscriptionCollectionViewHeaderViewID    = "kSubscriptionCollectionViewHeaderViewID"
    let kCollectionViewCellsHorizonMargin: CGFloat = 12.0
    let kCollectionViewCellHeight: CGFloat         = 30.0
    let kCollectionViewToLeftMargin: CGFloat       = 16.0
    let kCollectionViewToTopMargin: CGFloat        = 12.0
    let kCollectionViewToRightMargin: CGFloat      = 16.0
    let kCollectionViewToBottomtMargin: CGFloat    = 10.0
    let kCellBtnCenterToBorderMargin: CGFloat      = 19.0
    
    private lazy var dataSource: NSMutableArray = {
        let ds = NSMutableArray()
        return ds
    } ()
    
    convenience init(ed: [String], un: [String]) {
        self.init()
        dataSource.addObject(ed)
        dataSource.addObject(un)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        initCollectionView()
    }
    
    private func initCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(SubscriptionCollectionViewCell.self, forCellWithReuseIdentifier: kSubscriptionCollectionViewCellID)
        collectionView.registerClass(SubscriptionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kSubscriptionCollectionViewHeaderViewID)
        view.addSubview(collectionView)
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var set1 = (indexPath.section == 0 ? dataSource[1] : dataSource[0]) as! [String]
        var set2 = (indexPath.section == 1 ? dataSource[1] : dataSource[0]) as! [String]
        set1.append(set2[indexPath.row])
        set2.removeAtIndex(indexPath.row)
        print(set1, set2)
//        set1.addObject(set2[indexPath.row])
//        set2.removeObject(indexPath.row)
        
        dataSource.removeAllObjects()
        dataSource.addObject(set1)
        dataSource.addObject(set2)
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let set = dataSource[section] as! [String]
        return set.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kSubscriptionCollectionViewCellID, forIndexPath: indexPath) as! SubscriptionCollectionViewCell
        cell.titleLabel?.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)
        let set = dataSource[indexPath.section]
        let text = set[indexPath.row] as! String
        cell.titleLabel?.text = text
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kSubscriptionCollectionViewHeaderViewID, forIndexPath: indexPath) as! SubscriptionHeader
            header.titleLabel?.text = indexPath.section == 0 ? "subscriptions" : "unsubscriptions"
            return header
        }
        return UICollectionReusableView()
    }
    
    
    // MARK: - UICollectionViewDelegateLeftAlignedLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let set = dataSource[indexPath.section]
        let text = set[indexPath.row]
        let cellWidth = getCollectionCellWidth(text as! String)
        return CGSizeMake(cellWidth, kCollectionViewCellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kCollectionViewCellsHorizonMargin
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.width - 50, 38)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(kCollectionViewToTopMargin, kCollectionViewToLeftMargin, kCollectionViewToBottomtMargin, kCollectionViewToRightMargin)
    }
    
    // MARK: - private calc methods
    private func checkCellLimitWidth(cellWidth: CGFloat, isLimitWidth: IsLimitWidth?) -> CGFloat {
        var cw = cellWidth
        let limitWidth = CGRectGetWidth(collectionView.frame) - kCollectionViewToLeftMargin - kCollectionViewToRightMargin
        if cw >= limitWidth {
            cw = limitWidth
//            isLimitWidth != nil ? IsLimitWidth(true, cw) : nil
            return cw
        }
//        IsLimitWidth ? IsLimitWidth(false, cw) : nil
        return cw
    }
    
    
    
    private func getCollectionCellWidth(text: String) -> CGFloat {
        var width: CGFloat
        let tempText = text as NSString
        let size = tempText.sizeWithAttributes([NSFontAttributeName : UIFont.systemFontOfSize(13.0)])
        let w = Float(size.width)
        width = CGFloat(ceilf(w)) + kCellBtnCenterToBorderMargin
        width = checkCellLimitWidth(width, isLimitWidth: nil)
        return width
    }
    
    
    private lazy var collectionView: UICollectionView = {
        let cf = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 40)
        let ly = SubscriptionViewLayout()
        let cv = UICollectionView(frame: cf, collectionViewLayout: ly)
        cv.backgroundColor = .whiteColor()
        cv.allowsMultipleSelection = true
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
        cv.scrollsToTop = false
        return cv
    } ()
}