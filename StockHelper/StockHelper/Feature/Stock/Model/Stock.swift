//
//  Stock.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/9/19.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import Foundation

public enum HotLevel:Int {
    case NoLevel = 0
    case Level1 = 1
    case Level2
    case Level3
    case Level4
    case Level5
    case Level6
    case Level7
    case Level8
    case Level9
    case Level10
}

public enum StockType:Int {
    case SH = 1
    case SZ = 2
}

public enum StockPeriodType:Int {
    case ONE_MINUTE = 1
    case FIVE_MINUTES = 2
    case THIRTY_MINUTES = 4
    case DAY = 6
    case WEEK = 7
    case MONTH = 8
}

public protocol HotLevelable {
    var hotLevel: HotLevel { get set }
    var importantLevel: HotLevel { get set }
}

class Stock:Codable,Hashable {
    static func == (lhs: Stock, rhs: Stock) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.code)
        hasher.combine(self.name)
    }
    init(code:String,name:String) {
        self.code = code
        self.name = name
    }
    var code:String = "";
    var name:String = "";
    var pinyin:String = "";
    var tradeValue: String = "0";
    var gnListStr: String = ""
    var zt: Int = 0;
    var gnList:[String] {
        return gnListStr.split(separator: ";").map(String.init)
    }
    var formatMoney:String {
        let tradeValueInt:Float = Float(self.tradeValue) ?? 0
        if tradeValueInt < 10000 {
            return "\(tradeValueInt)"
        };
        if tradeValueInt < 100000000  {
            return "\((tradeValueInt/10000).roundedDot1Float)万"
        }
        return "\((tradeValueInt/100000000).roundedDot1Float)亿"
    }
    var description:String {
        return "\(code) \(name)"
    }
    
    enum CodingKeys : String, CodingKey {
        case code
        case name
        case pinyin
        case tradeValue
        case gnListStr
        case zt
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        code = try container.decode(String.self, forKey: .code)
        pinyin = try container.decode(String.self, forKey: .pinyin)
        tradeValue = try container.decode(String.self, forKey: .tradeValue)
        gnListStr = try container.decode(String.self, forKey: .gnListStr)
        zt = try container.decode(Int.self, forKey: .zt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(code, forKey: .code)
        try container.encode(pinyin, forKey: .pinyin)
        try container.encode(tradeValue, forKey: .tradeValue)
        try container.encode(gnListStr, forKey: .gnListStr)
        try container.encode(zt, forKey: .zt)
    }
}

class YingLiStock:Codable,Hashable {
    static func == (lhs: YingLiStock, rhs: YingLiStock) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.code)
    }
    init(code:String) {
        self.code = code
    }
    var code:String = "";
    var tradeValue: String = "0";
    var yingliValue: String = "0";
    var yingshouValue: String = "0"
    var yingliRise: String = "0"
    
    var description:String {
        return "\(code) \(yingliValue) \(yingliRise)"
    }
    
    enum CodingKeys : String, CodingKey {
        case code
        case yingliValue
        case tradeValue
        case yingshouValue
        case yingliRise
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        yingliValue = try container.decode(String.self, forKey: .yingliValue)
        tradeValue = try container.decode(String.self, forKey: .tradeValue)
        yingshouValue = try container.decode(String.self, forKey: .yingshouValue)
        yingliRise = try container.decode(String.self, forKey: .yingliRise)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(yingliValue, forKey: .yingliValue)
        try container.encode(tradeValue, forKey: .tradeValue)
        try container.encode(yingshouValue, forKey: .yingshouValue)
        try container.encode(yingliRise, forKey: .yingliRise)
    }
}

class NiuKuiStock:Codable,Hashable {
    static func == (lhs: NiuKuiStock, rhs: NiuKuiStock) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.code)
    }
    init(code:String) {
        self.code = code
    }
    var code:String = "";
    //流通市值
    var tradeValue: String = "0";
    //盈利
    var yingliValue: String = "0";
    //上期盈利
    var lastYingliValue: String = "0"
    // 利润变动
    var yingliRise: String = "0"
    // 预告日期
    var yugaoDate: String = ""
    
    var description:String {
        return "\(code) \(yingliValue) \(yingliRise)"
    }
    
    enum CodingKeys : String, CodingKey {
        case code
        case yingliValue
        case tradeValue
        case lastYingliValue
        case yingliRise
        case yugaoDate
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        yingliValue = try container.decode(String.self, forKey: .yingliValue)
        tradeValue = try container.decode(String.self, forKey: .tradeValue)
        lastYingliValue = try container.decode(String.self, forKey: .lastYingliValue)
        yingliRise = try container.decode(String.self, forKey: .yingliRise)
        yugaoDate = try container.decode(String.self, forKey: .yugaoDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(yingliValue, forKey: .yingliValue)
        try container.encode(tradeValue, forKey: .tradeValue)
        try container.encode(lastYingliValue, forKey: .lastYingliValue)
        try container.encode(yingliRise, forKey: .yingliRise)
        try container.encode(yugaoDate, forKey: .yugaoDate)
    }
}


class HotStock:HotLevelable {
    var stock:Stock
    var block:Block
    var hotLevel:HotLevel = .NoLevel
    var importantLevel:HotLevel = .NoLevel
    init(stock:Stock,block:Block) {
        self.stock = stock
        self.block = block
    }
    var key: String {
        return "\(stock.code)_\(block.code)"
    }
}

class Stock2Blocks:Stock {
    init(stock:Stock) {
        super.init(code: stock.code, name: stock.name)
        self.pinyin = stock.pinyin
        self.tradeValue = stock.tradeValue
        self.gnListStr = stock.gnListStr
    }
    lazy var blocks:[Block] = []
    required init(from decoder: Decoder) throws {
//        fatalError("init(from:) has not been implemented")
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try values.decode(String.self, forKey: .code)
        self.name = try values.decode(String.self, forKey: .name)
    }
}
