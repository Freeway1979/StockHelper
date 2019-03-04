//
//  Float+Format.swift
//  StockHelper
//
//  Created by andyli2 on 2018/12/13.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import Foundation

extension Float {
    var dot2Float:Float {
        return Float(String(format: "%.2f", self))!
    }
    var dot2String:String {
        return String(format: "%.2f", self)
    }
    var roundedDot2Float:Float {
        return (floorf(self * 100 + 0.56))/100
    }
}
