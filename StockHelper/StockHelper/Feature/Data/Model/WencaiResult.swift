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

class WenCaiBlockStat {
    var title:String = "" //板块名称
    var money:Int = 0 //板块资金量
    var zhangting:Int = 0 //板块涨停数
    var zhangfu:Float = 0.0 //板块涨幅
    var score: Int = 0 // 得分
    
    func buildScore()  {
        var score: Int = zhangting * 100;
        score = score + Int(zhangfu * 100)
        score = score + Int(money / 100000000 * 100)
        self.score = score
    }
}

