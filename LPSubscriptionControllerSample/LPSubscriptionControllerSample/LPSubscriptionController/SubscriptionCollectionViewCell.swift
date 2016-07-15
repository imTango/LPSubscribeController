//
//  SubscriptionCollectionViewCell.swift
//  LPSubscriptionControllerSample
//
//  Created by litt1e-p on 16/5/27.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

import UIKit

class SubscriptionCollectionViewCell: UICollectionViewCell
{
    var titleLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func sharedInit() {
        titleLabel                      = UILabel(frame: CGRectMake(0, 0, bounds.size.width, bounds.size.height))
        titleLabel?.textAlignment       = .Center
        titleLabel?.font                = UIFont.systemFontOfSize(14.0)
        titleLabel?.layer.cornerRadius  = 5.0
        titleLabel?.backgroundColor     = .whiteColor()
        titleLabel?.layer.borderWidth   = 1.0
        titleLabel?.layer.masksToBounds = true
        contentView.addSubview(titleLabel!)
    }
}
