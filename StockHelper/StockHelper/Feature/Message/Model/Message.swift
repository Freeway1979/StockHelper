//
//  Message.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/9/19.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import Foundation

enum MessageLevel:String {
    case High = "重要"
    case Normal = "一般"
    case Low = "次要"
}

struct Message:Decodable {
    var keywords:[String]
    var stocks:[String]
    
    var displayTitle: String {
        return keywords.joined(separator: " ")
    }
    var displayStocks: String {
        return stocks.joined(separator: " ")
    }
}

