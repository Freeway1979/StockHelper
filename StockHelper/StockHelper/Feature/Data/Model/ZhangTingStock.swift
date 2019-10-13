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
    var name:String = ""
    //连续涨停天数
    var zhangting:Int = 0
    //涨停原因
    var ztYuanYin:String = ""
    //涨停板数类别
    var ztBanType:String = ""
    //首次涨停时间
    var ztFirstTime:String = ""
    //最后涨停时间
    var ztLastTime:String = ""
    //涨停封单金额
    var ztMoney:String = ""
    //涨停封单量
    var ztBiils:String = ""
    //涨停封成比
    var ztRatioBills:String = ""
    //涨停封流比
    var ztRatioMoney:String = ""
    //开板次数
    var ztKaiBan:Int = 0
    var gnListStr:String = ""
    var gnList:[String] {
        return gnListStr.toList(separator: ";")
    }
    
    required init(code:String, zhangting:Int) {
        self.code = code
        self.zhangting = zhangting
    }
    
    enum CodingKeys : String, CodingKey {
        case code
        case zhangting
        case name
        case ztYuanYin
        case ztBanType
        case ztFirstTime
        case ztLastTime
        case ztMoney
        case ztBiils
        case ztRatioBills
        case ztRatioMoney
        case ztKaiBan
        case gnListStr
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        zhangting = try container.decode(Int.self, forKey: .zhangting)
        name = try container.decode(String.self, forKey: .name)
        ztYuanYin = try container.decode(String.self, forKey: .ztYuanYin)
        ztBanType = try container.decode(String.self, forKey: .ztBanType)
        ztFirstTime = try container.decode(String.self, forKey: .ztFirstTime)
        ztLastTime = try container.decode(String.self, forKey: .ztLastTime)
        ztMoney = try container.decode(String.self, forKey: .ztMoney)
        ztBiils = try container.decode(String.self, forKey: .ztBiils)
        ztRatioBills = try container.decode(String.self, forKey: .ztRatioBills)
        ztRatioMoney = try container.decode(String.self, forKey: .ztRatioMoney)
        ztKaiBan = try container.decode(Int.self, forKey: .ztKaiBan)
        gnListStr = try container.decode(String.self, forKey: .gnListStr)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(zhangting, forKey: .zhangting)
        try container.encode(name, forKey: .name)
        try container.encode(ztYuanYin, forKey: .ztYuanYin)
        try container.encode(ztBanType, forKey: .ztBanType)
        try container.encode(ztFirstTime, forKey: .ztFirstTime)
        try container.encode(ztLastTime, forKey: .ztLastTime)
        try container.encode(ztMoney, forKey: .ztMoney)
        try container.encode(ztBiils, forKey: .ztBiils)
        try container.encode(ztRatioBills, forKey: .ztRatioBills)
        try container.encode(ztRatioMoney, forKey: .ztRatioMoney)
        try container.encode(ztKaiBan, forKey: .ztKaiBan)
        try container.encode(gnListStr, forKey: .gnListStr)
    }
}

