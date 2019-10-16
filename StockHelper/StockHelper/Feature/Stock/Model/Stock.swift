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

class StockExtra: Codable,Hashable {
    var code:String = "";
    //自定义标签
    var tags:String = ""
    //备注
    var memo:String = ""
    //历史联动股票
    var twimCode:String = ""
    
    var tagList:[String] {
        return tags.toList(separator: ";")
    }
    
    static func == (lhs: StockExtra, rhs: StockExtra) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.code)
    }
    
    init(code:String) {
        self.code = code
    }
    
    //序列化
    enum CodingKeys : String, CodingKey {
        case code
        case tags
        case memo
        case twimCode
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        tags = try container.decode(String.self, forKey: .tags)
        memo = try container.decode(String.self, forKey: .memo)
        twimCode = try container.decode(String.self, forKey: .twimCode)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(tags, forKey: .tags)
        try container.encode(memo, forKey: .memo)
        try container.encode(twimCode, forKey: .twimCode)
    }
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
    
    var gnList:[String] {
        return gnListStr.toList(separator: ";")
    }
    var extra: StockExtra? {
       return StockUtils.getStockExtra(code: code)
    }
    //120日内涨停数
    var zts:Int {
        let s:ZhangTingShuStock? = StockUtils.getZhangTingShuStock(by: code)
        if s != nil {
            return (s?.zt.numberValue!.intValue)!
        }
        return 0
    }
    
    var yingliStr:String? {
        let s:YingLiStock? = StockUtils.getYingLiStock(by: code)
        if s != nil {
            return "盈利:\(s!.yingliRise.formatDot2FloatString)%"
        }
        return nil
    }

    var jiejinStr:String? {
        let s:JieJinStock? = StockUtils.getJieJinStocks(by: code).first
        if s != nil {
           let date = s!.date
           let today = Date()
           let future = Date(timeInterval: 3600 * 24 * 30, since: today).formatWencaiDateString().replacingOccurrences(of: ".", with: "")
           let rs = future.compare(date)
           if rs != .orderedAscending {
              return "解禁:\(date)"
           }
        }
        return nil
    }
    
    var formatMoney:String {
        return self.tradeValue.formatMoney
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
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        code = try container.decode(String.self, forKey: .code)
        pinyin = try container.decode(String.self, forKey: .pinyin)
        tradeValue = try container.decode(String.self, forKey: .tradeValue)
        gnListStr = try container.decode(String.self, forKey: .gnListStr)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(code, forKey: .code)
        try container.encode(pinyin, forKey: .pinyin)
        try container.encode(tradeValue, forKey: .tradeValue)
        try container.encode(gnListStr, forKey: .gnListStr)
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

class ZhangTingShuStock:Codable,Hashable {
    static func == (lhs: ZhangTingShuStock, rhs: ZhangTingShuStock) -> Bool {
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
    var zt: String = "0";

    var description:String {
        return "\(code) \(zt)"
    }
    
    enum CodingKeys : String, CodingKey {
        case code
        case zt
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        zt = try container.decode(String.self, forKey: .zt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(zt, forKey: .zt)
    }
}

class JieJinStock:Codable,Hashable {
    static func == (lhs: JieJinStock, rhs: JieJinStock) -> Bool {
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
    //解禁日志
    var date: String = "";
    //比例
    var ratio: String = "0";
    //金额
    var money: String = "0"
    //类型
    var type: String = ""
    // 成本
    var price: String = "0"
    
    var description:String {
        return "\(code) \(date) \(ratio)"
    }
    
    enum CodingKeys : String, CodingKey {
        case code
        case date
        case ratio
        case money
        case type
        case price
        case yugaoDate
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        date = try container.decode(String.self, forKey: .date)
        ratio = try container.decode(String.self, forKey: .ratio)
        money = try container.decode(String.self, forKey: .money)
        type = try container.decode(String.self, forKey: .type)
        price = try container.decode(String.self, forKey: .price)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(date, forKey: .date)
        try container.encode(ratio, forKey: .ratio)
        try container.encode(money, forKey: .money)
        try container.encode(type, forKey: .type)
        try container.encode(price, forKey: .price)
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
