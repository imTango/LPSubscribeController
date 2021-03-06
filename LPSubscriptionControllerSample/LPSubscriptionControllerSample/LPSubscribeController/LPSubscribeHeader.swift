//
//  LPSubscribeHeader.swift
//  LPSubscriptionControllerSample
//
//  Created by litt1e-p on 16/7/11.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

import UIKit

enum LPSubscribeBtnState: UInt
{
    case Completed, Editing
}

typealias ClickBlock = ((state: LPSubscribeBtnState) -> Void)?

class LPSubscribeHeader: UICollectionReusableView
{
    var clickBlock: ClickBlock
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRectMake(10, 0, 200, self.bounds.size.height)
        clickButton.frame = CGRectMake(SCREEN_SIZE.width - 180, 10, 160, self.bounds.size.height)
    }
    
    @objc private func clickEvent(btn: UIButton) {
        clickButton.selected = !clickButton.selected
        clickBlock!(state: btn.selected ? .Editing : .Completed)
    }
    
    private func configSubViews() {
        addSubview(titleLabel)
        addSubview(clickButton)
    }
    
    internal lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFontOfSize(17.0)
        tl.textColor = RGBA(51, 51, 51, 1)
        return tl
    } ()
    
    internal var buttonHidden = false {
        willSet {
            if newValue != buttonHidden {
                clickButton.hidden = newValue
            }
        }
    }
    
    internal lazy var clickButton: UIButton = {
        let cb = UIButton()
        cb.titleLabel?.font = UIFont.systemFontOfSize(13.0)
        cb.backgroundColor = .whiteColor()
        cb.layer.masksToBounds = true
        cb.layer.cornerRadius = 10.0
        cb.layer.borderColor = RGBA(214, 39, 48, 1).CGColor
        cb.layer.borderWidth = 0.7
        cb.setTitle(kLPSCEditDesc, forState: .Normal)
        cb.setTitle(kLPSCEditCompleteDesc, forState: .Selected)
        cb.setTitleColor(RGBA(214, 39, 48, 1), forState: .Normal)
        cb.titleLabel?.font = UIFont.systemFontOfSize(17.0)
        cb.addTarget(self, action: #selector(clickEvent(_:)), forControlEvents: .TouchUpInside)
        return cb
    } ()
}
