//
//  LPSubscribeLeftAlignLayout.swift
//  LPSubscriptionControllerSample
//
//  Created by paul on 16/7/15.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

import UIKit

class LPSubscribeLeftAlignLayout: UICollectionViewFlowLayout
{
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesRes = NSArray(array: super.layoutAttributesForElementsInRect(rect)!, copyItems: true)
        guard attributesRes.count > 0 else {return attributesRes as? [UICollectionViewLayoutAttributes]}
        for attr in attributesRes as! [UICollectionViewLayoutAttributes] {
            if nil == attr.representedElementKind {
                let indexPath = attr.indexPath
                attr.frame = (layoutAttributesForItemAtIndexPath(indexPath)?.frame)!
            }
        }
        return attributesRes as! [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let currentItemAttributes = super.layoutAttributesForItemAtIndexPath(indexPath)?.copy() as! UICollectionViewLayoutAttributes
        let sectionInset          = evaluatedSectionInsetForItem(indexPath.section)
        let isFirstItemInSection  = indexPath.item == 0
        let layoutWidth           = CGRectGetWidth((collectionView?.frame)!) - sectionInset.left - sectionInset.right
        if isFirstItemInSection {
            currentItemAttributes.leftAlignFrame(sectionInset)
            return currentItemAttributes
        }
        let previousIndexPath       = NSIndexPath(forItem: indexPath.item - 1, inSection: indexPath.section)
        let previousFrame           = layoutAttributesForItemAtIndexPath(previousIndexPath)?.frame
        let previousFrameRightPoint = (previousFrame?.origin.x)! + (previousFrame?.size.width)!
        let currentFrame            = currentItemAttributes.frame
        let strecthedCurrentFrame   = CGRectMake(sectionInset.left, currentFrame.origin.y, layoutWidth, currentFrame.size.height)
        let isFirstItemInRow        = !CGRectIntersectsRect(previousFrame!, strecthedCurrentFrame)
        if isFirstItemInRow {
            currentItemAttributes.leftAlignFrame(sectionInset)
            return currentItemAttributes
        }
        var currentItemFrame        = currentItemAttributes.frame
        currentItemFrame.origin.x   = previousFrameRightPoint + evaluatedMinimumInteritemSpacingForItem(indexPath.row)
        currentItemAttributes.frame = currentItemFrame
        return currentItemAttributes
    }
    
    private func evaluatedSectionInsetForItem(index: NSInteger) -> UIEdgeInsets {
        return sectionInset
        guard collectionView?.delegate != nil else {return sectionInset}
        if collectionView!.delegate!.respondsToSelector(#selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:insetForSectionAtIndex:))) {
            let delegate = collectionView?.delegate as! UICollectionViewDelegateLeftAlignedLayout
            return delegate.collectionView!(collectionView!, layout: self, insetForSectionAtIndex: index)
        } else {
            return sectionInset
        }
    }
    
    private func evaluatedMinimumInteritemSpacingForItem(index: NSInteger) -> CGFloat {
        return minimumLineSpacing
        if ((collectionView?.delegate?.respondsToSelector(#selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:minimumLineSpacingForSectionAtIndex:)))) != nil)  {
            let delegate = collectionView?.delegate as! UICollectionViewDelegateLeftAlignedLayout
            return delegate.collectionView!(collectionView!, layout: self, minimumLineSpacingForSectionAtIndex: index)
        } else {
            return minimumLineSpacing
        }
    }
}

protocol UICollectionViewDelegateLeftAlignedLayout: UICollectionViewDelegateFlowLayout {
    
}

extension UICollectionViewLayoutAttributes
{
    public func leftAlignFrame(sectionInset: UIEdgeInsets) {
        var tempFrame = frame
        tempFrame.origin.x = sectionInset.left
        frame = tempFrame
    }
}
