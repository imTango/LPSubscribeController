//
//  LPSubscribeLayout.swift
//  LPSubscriptionControllerSample
//
//  Created by paul on 16/7/15.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

import UIKit

public protocol UICollectionViewItemSizeLayoutDelegate: UICollectionViewDelegateFlowLayout{}

class LPSubscribeLayout: UICollectionViewFlowLayout
{
    private let kJLFilterLayoutHeaderH: CGFloat        = 35.0
    private let kJLFilterLayoutFooterH: CGFloat        = 0.5
    private let kJLFilterRadioHeaderH: CGFloat         = 40.0
    private let kJLFilterInputItemH: CGFloat           = 50.0
    private let kJLFilterRadioItemsMarginLeft: CGFloat = 20.0
    private let kJLFilterRadioItemMarginX: CGFloat     = 15.0
    private let kJLFilterRadioItemMarginY: CGFloat     = 15.0
    
    private var attrs: [UICollectionViewLayoutAttributes]  = [UICollectionViewLayoutAttributes]()
    private var contentY: CGFloat                          = 0.0
    private var prevAttr: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes()
    
    override func prepareLayout() {
        super.prepareLayout()
        attrs.removeAll()
        contentY = kJLFilterLayoutHeaderH
        let n    = collectionView!.numberOfSections()
        for i in 0 ..< n {
            let c = collectionView!.numberOfItemsInSection(i)
            let indexPath = NSIndexPath(forItem: 0, inSection: i)
            prevAttr      = UICollectionViewLayoutAttributes()
            attrs.append(layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath)!)
            contentY += kJLFilterRadioHeaderH + kJLFilterRadioItemMarginY
            for j in 0 ..< c {
                let indexPath = NSIndexPath(forItem: j, inSection: i)
                let s = evaluatedItemSize(indexPath)
                var x = kJLFilterRadioItemsMarginLeft
                
                let attr  = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                let pMaxX = IsEmptyRect(prevAttr.frame) ?  x : CGRectGetMaxX(prevAttr.frame) +  kJLFilterRadioItemMarginX
                if pMaxX + s.width + 2 * kJLFilterRadioItemMarginX > collectionView?.frame.size.width {
                    contentY += s.height + kJLFilterRadioItemMarginY
                } else {
                    x = pMaxX
                }
                let y = contentY
                attr.frame = CGRectMake(x, y, s.width, s.height)
                attrs.append(attr)
                prevAttr = attr
                if j == c - 1 {
                    contentY += s.height + kJLFilterRadioItemMarginY
                    if i == n - 1 {
                        contentY += s.height + kJLFilterLayoutHeaderH
                    }
                }
            }
        }
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes: UICollectionViewLayoutAttributes
        if elementKind == UICollectionElementKindSectionHeader {
            attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: indexPath)
            let h = indexPath.section == 0 ? kJLFilterLayoutHeaderH : kJLFilterRadioHeaderH
            attributes.frame = CGRectMake(0, contentY, collectionView!.frame.size.width, h)
        } else {
            attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withIndexPath: indexPath)
            attributes.frame = CGRectMake(0, contentY, collectionView!.frame.size.width, kJLFilterLayoutFooterH)
        }
        return attributes
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrs
    }
    
    override func collectionViewContentSize() -> CGSize {
        super.collectionViewContentSize()
        return CGSizeMake(0, contentY)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    private func evaluatedItemSize(indexPath: NSIndexPath) -> CGSize {
        guard collectionView?.delegate != nil else { return itemSize }
        if collectionView!.delegate!.respondsToSelector(#selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:sizeForItemAtIndexPath:))) {
            let delegate = collectionView!.delegate as! UICollectionViewItemSizeLayoutDelegate
            return delegate.collectionView!(collectionView!, layout: self, sizeForItemAtIndexPath: indexPath)
        } else {
            return itemSize
        }
    }
    
    private let IsEmptyRect: (CGRect?) -> Bool = {
        (ref: CGRect?) -> Bool in
        if ref == nil || CGRectIsEmpty(ref!) || CGRectIsNull(ref!) || CGRectEqualToRect(ref!, CGRectZero) {
            return true
        } else {
            return false
        }
    }
}
