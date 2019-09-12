//
//  ZhangTingStock.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/12.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class ZhangTingStocks:Codable,Hashable {
    static func == (lhs: ZhangTingStocks, rhs: ZhangTingStocks) -> Bool {
        return lhs.date == rhs.date
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.date)
    }
    var date:String = ""
    var stocks:[ZhangTingStock] = []
    required init(date:String, stocks:[ZhangTingStock]) {
        self.date = date
        self.stocks = stocks
    }
    
    enum CodingKeys : String, CodingKey {
        case date
        case stocks
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(String.self, forKey: .date)
        stocks = try container.decode([ZhangTingStock].self, forKey: .stocks)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(stocks, forKey: .stocks)
    }
}

class ZhangTingStock:Codable,Hashable {
    static func == (lhs: ZhangTingStock, rhs: ZhangTingStock) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.code)
    }
    
    var code:String = ""
    //连续涨停天数
    var zhangting:Int = 0
    
    required init(code:String, zhangting:Int) {
        self.code = code
        self.zhangting = zhangting
    }
    
    enum CodingKeys : String, CodingKey {
        case code
        case zhangting
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        zhangting = try container.decode(Int.self, forKey: .zhangting)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(zhangting, forKey: .zhangting)
    }
}

