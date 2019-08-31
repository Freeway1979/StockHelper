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
