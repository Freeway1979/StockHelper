//
//  Stock.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/9/19.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import Foundation

class Stock:Decodable {
    var code:String = "";
    var name:String = "";
    enum CodingKeys : String, CodingKey {
        case code
        case name
    }
}


class Stock2Blocks:Stock {
    init(stock:Stock) {
        super.init()
        self.code = stock.code
        self.name = stock.name
    }
    
    required init(from decoder: Decoder) throws {
//        fatalError("init(from:) has not been implemented")
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try values.decode(String.self, forKey: .code)
        self.name = try values.decode(String.self, forKey: .name)
    }
}
