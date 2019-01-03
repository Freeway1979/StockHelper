//
//  Stock.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/9/19.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import Foundation

struct Stock:Decodable {
    var code:String = "";
    var name:String = "";
}

extension Stock {
    var isTopPrice: Bool {
        return false;
    }
    var isBottomPrice: Bool {
        return false;
    }
}
