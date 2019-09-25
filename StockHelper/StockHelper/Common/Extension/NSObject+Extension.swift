//
//  NSObject+Extension.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/22.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

extension NSObject {
    var theClassName:String {
        return NSStringFromClass(type(of: self))
    }
}
