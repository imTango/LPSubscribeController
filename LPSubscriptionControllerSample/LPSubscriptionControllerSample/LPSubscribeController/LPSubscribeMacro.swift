//
//  LPSubscribeMacro.swift
//  LPSubscriptionControllerSample
//
//  Created by litt1e-p on 16/7/11.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

import Foundation
import UIKit

let SCREEN_SIZE = UIScreen.mainScreen().bounds.size
let SPACE: CGFloat = 10.0

let RGBA: (CGFloat, CGFloat, CGFloat, CGFloat) -> UIColor = {
    (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)->UIColor in
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

let kLPSCEditDesc = "sort or delete"
let kLPSCEditCompleteDesc = "done"
let kLPSCDidSelectedDesc = "selected"
let kLPSCAddMoreDesc = "add more"

let kLPSCAddAnimationDuration = 0.25

//let kLPSCCellIdentifier = "kLPSCCellIdentifier"
let kLPSCSectionHeaderOneIdentifier = "kLPSCSectionHeaderOneIdentifier"
let kLPSCSectionHeaderTwoIdentifier = "kLPSCSectionHeaderTwoIdentifier"

func exchange<T>(inout data: [T], i: Int, j: Int) {
    guard data.count > i && data.count > j else {return}
    swap(&data[i], &data[j])
}