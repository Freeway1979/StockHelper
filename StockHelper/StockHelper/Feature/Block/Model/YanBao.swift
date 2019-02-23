//
//  YaoBao.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/2/17.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class YanBao : Decodable {
    var title:String
    var file:String
    enum CodingKeys : String, CodingKey {
        case title
        case file
    }
}
