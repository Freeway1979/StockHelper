//
//  WencaiResult.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/4/21.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
//一亿
let YIYI:Int64 = 100000000
let YI100:Int64 = 100*YIYI

struct WenCaiBlockStat {
    var title:String
    var money:Float //板块资金量
    var zhangting:Int //板块涨停数
    var zhangfu:Float //板块涨幅
    var score: Float
}

