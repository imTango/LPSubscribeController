//
//  LPSubscribeCell.swift
//  LPSubscriptionControllerSample
//
//  Created by litt1e-p on 16/7/11.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

import UIKit


@objc protocol LPSubscribeCellDeleteDelegate: NSObjectProtocol
{
    optional func deleteItem(indexPath: NSIndexPath)
}

class LPSubscribeCell: UICollectionViewCell
{
    internal weak var delegate: LPSubscribeCellDeleteDelegate?
    
    internal var indexPath: NSIndexPath?
    
    internal func configCell(dataArray: [String]?, indexPath: NSIndexPath) {
        guard (dataArray?.count)! - 1 >= indexPath.item else {return}
        self.indexPath      = indexPath
        contentLabel.hidden = false
        contentLabel.text   = dataArray![indexPath.item]
        if indexPath.section == 0 && indexPath.item == 0 {
            contentLabel.textColor           = RGBA(214, 39, 48, 1)
            contentLabel.layer.masksToBounds = true
            contentLabel.layer.borderColor   = UIColor.clearColor().CGColor
            contentLabel.layer.borderWidth   = 0.0
        } else {
            contentLabel.textColor           = RGBA(101, 101, 101, 1)
            contentLabel.layer.masksToBounds = true
            contentLabel.layer.cornerRadius  = CGRectGetHeight(contentView.bounds) * 0.5
            contentLabel.layer.borderColor   = RGBA(211, 211, 211, 1).CGColor
            contentLabel.layer.borderWidth   = 0.45
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        confingSubViews()
        contentView.backgroundColor = .clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        guard gestureRecognizers?.count > 0 else {return}
        for ges in gestureRecognizers! {
            if ges.isKindOfClass(UIPanGestureRecognizer.self) {
                removeGestureRecognizer(ges)
            }
        }
    }
    
    private func confingSubViews() {
        contentView.addSubview(contentLabel)
        contentView.addSubview(deleteButton)
    }
    
    @objc private func deleteEvent(btn: UIButton) {
        if delegate != nil && delegate!.respondsToSelector(#selector(LPSubscribeCellDeleteDelegate.deleteItem(_:))) {
            delegate!.deleteItem!(indexPath!)
        }
    }
    
    internal lazy var deleteButton: UIButton = {
        let db = UIButton(frame: CGRectMake(0, 0, 10, 10))
        db.setBackgroundImage(UIImage(named: "delete"), forState: .Normal)
        db.addTarget(self, action: #selector(self.deleteEvent(_:)), forControlEvents: .TouchUpInside)
        return db
    } ()
    
    internal lazy var contentLabel: UILabel = {
        let cl = UILabel(frame: CGRectMake(0, 0, self.contentView.bounds.size.width , self.contentView.bounds.size.height))
        cl.center = self.contentView.center;
        cl.textAlignment = .Center
        cl.font = UIFont.systemFontOfSize(15.0)
        cl.numberOfLines = 1;
//        cl.adjustsFontSizeToFitWidth = true
//        cl.minimumScaleFactor = 0.1
        return cl
    } ()
}
