//
//  Int+Extension.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/4/14.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

public extension Int {
    static func randomIntNumber(lower: Int = 0,upper: Int = Int(UInt32.max)) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower)))
    }
    static func randomIntNumber(range: Range<Int>) -> Int {
        return randomIntNumber(lower: range.lowerBound, upper: range.upperBound)
    }
}
