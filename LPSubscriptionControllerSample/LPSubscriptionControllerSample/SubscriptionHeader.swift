//
//  SubscriptionHeader.swift
//  LPSubscriptionControllerSample
//
//  Created by litt1e-p on 16/5/27.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

import UIKit

class SubscriptionHeader: UICollectionReusableView
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
        backgroundColor = .groupTableViewBackgroundColor()
        titleLabel = UILabel(frame: CGRectMake(10, 0, frame.size.width - 10, frame.size.height))
        addSubview(titleLabel!)
    }

}
