//
//  Stock.swift
//  StockHelper
//
//  Created by andyli2 on 2018/9/19.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import Foundation

struct Stock {
    private var code:String = "";
    private var name:String = "";
    private var price:Float = 0.0;
    private var gainOfRiseFall:Float = 0.0;
    
    private var ma5:Float = 0.0;
    private var ma10:Float = 0.0;
    private var ma20:Float = 0.0;
    
}

extension Stock {
    var isTopPrice: Bool {
        return false;
    }
    var isBottomPrice: Bool {
        return false;
    }
}
