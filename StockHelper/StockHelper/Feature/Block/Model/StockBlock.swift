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
}

class Block:Decodable {
    var code:String = "";
    var name:String = "";
    var type:BlockType = .TypeGN ;
    enum CodingKeys : String, CodingKey {
        case code
        case name
        case type
    }
}

class Block2Stocks:Block
{
    var stocks:[Stock]? = [];
    init(block:Block) {
        super.init()
        self.code = block.code
        self.name = block.name
        self.type = block.type
    }
    
    required init(from decoder: Decoder) throws {
//        fatalError("init(from:) has not been implemented")
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try values.decode(String.self, forKey: .code)
        self.name = try values.decode(String.self, forKey: .name)
        self.type = BlockType(rawValue: try values.decode(String.self, forKey: .type))!
    }
}
