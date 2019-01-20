//
//  Block2Stocks.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/9/19.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit

enum BlockType:String,Decodable {
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

class Block:Decodable {
    var code:String = "";
    var name:String = "";
    var type:BlockType = .TypeGN ;
    var pinyin:String = "";
    enum CodingKeys : String, CodingKey {
        case code
        case name
        case type
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
