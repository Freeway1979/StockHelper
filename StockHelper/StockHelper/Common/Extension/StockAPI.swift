//
//  StockAPI.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/2/22.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

struct StockAPI {
    struct SINA {
        public static func HQ(type:String,code:String) -> String {
            return "http://hq.sinajs.cn/list=\(type)\(code)"
        }
    }
}
