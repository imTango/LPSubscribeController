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
            contentLabel.layer.cornerRadius  = CGRectGetHeight(contentView.bounds) * 0.3
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentLabel.frame = CGRectMake(0, 0, contentView.bounds.size.width, contentView.bounds.size.height)
        deleteButton.frame =  CGRectMake(0, 0, contentView.bounds.size.height * 0.3, contentView.bounds.size.height * 0.3)
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
        let db = UIButton()
        db.setBackgroundImage(UIImage(named: "delete"), forState: .Normal)
        db.addTarget(self, action: #selector(self.deleteEvent(_:)), forControlEvents: .TouchUpInside)
        return db
    } ()
    
    internal lazy var contentLabel: UILabel = {
        let cl = UILabel()
        cl.textAlignment = .Center
        cl.font = UIFont.systemFontOfSize(15.0)
        return cl
    } ()
}
