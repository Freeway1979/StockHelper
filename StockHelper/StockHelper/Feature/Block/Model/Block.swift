//
//  Block2Stocks.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/9/19.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit

enum BlockType:String,Codable {
    case TypeGN = "gn"
    case TypeHY = "hy"
    case TypeDY = "dy"
    
    var localizedString:String {
        if self == .TypeDY {
            return "地域"
        } else if self == .TypeGN {
            return "概念"
        } else if self == .TypeHY {
            return "行业"
        }
        return self.rawValue
    }
}

class Block:Codable {
    var code:String = "";
    var name:String = "";
    var type:BlockType = .TypeGN ;
    var pinyin:String = "";
    
    var description:String {
        return "\(code) \(name) \(type)"
    }
    
    init(code:String, name:String) {
        self.code = code
        self.name = name
    }
    
    enum CodingKeys : String, CodingKey {
        case code
        case name
        case type
        case pinyin
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        code = try container.decode(String.self, forKey: .code)
        type = try container.decode(BlockType.self, forKey: .type)
        pinyin = try container.decode(String.self, forKey: .pinyin)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(code, forKey: .code)
        try container.encode(type, forKey: .type)
        try container.encode(pinyin, forKey: .pinyin)
    }
}

/// TODO: 使用Extension实现比较好
class HotBlock:HotLevelable {
    var block:Block
    static var NoLevel = -1
    var hotLevel:HotLevel = .NoLevel
    var importantLevel:HotLevel = .NoLevel
    
    init(block:Block) {
        self.block = block
    }
}

class Block2Stocks
{
    var block:Block
    var stocks:[Stock]? = [];
    init(block:Block) {
        self.block = block
    }
    public func leadStocks() -> [Stock] {
       return self.stocks?.filter({ [weak self] (stock) -> Bool in
        return StockServiceProvider.isHotStock(stock: stock, block: (self?.block)!);
       }) ?? []
    }
}
