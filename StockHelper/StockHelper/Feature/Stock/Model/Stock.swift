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
class Stock:Decodable,Hashable {
    static func == (lhs: Stock, rhs: Stock) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    var hashValue:Int {
        get {
            return "\(self.code)_\(self.name)".hashValue
        }
    }
    var code:String = "";
    var name:String = "";
    var pinyin:String = "";
    enum CodingKeys : String, CodingKey {
        case code
        case name
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
        super.init()
        self.code = stock.code
        self.name = stock.name
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
