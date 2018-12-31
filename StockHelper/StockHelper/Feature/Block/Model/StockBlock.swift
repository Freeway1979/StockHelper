//
//  StockBlock.swift
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

struct StockBlock:Decodable
{
     var code:String = "";
     var name:String = "";
     var type:BlockType = .TypeGN ;
     var stocks:[Stock]? = [];
    
    enum CodingKeys : String, CodingKey {
        case code
        case name
        case type
        case stocks
    }

}
