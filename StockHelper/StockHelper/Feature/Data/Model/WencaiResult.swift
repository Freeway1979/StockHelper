//
//  WencaiResult.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/4/21.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
//一亿
let YIYI:Int = 100000000
let YI100:Int = 100*YIYI

class WenCaiBlockStat : Codable {
    var title:String = "" //板块名称
    var money:Int = 0 //板块资金量
    var zhangting:Int = 0 //板块涨停数
    var zhangfu:Float = 0.0 //板块涨幅
    var score: Int = 0 // 得分
    var ztNames: String = "" //涨停股票列表
    
    func buildScore()  {
        var score: Int = zhangting * 100;
        score = score + Int(zhangfu * 100)
        if zhangting > 0 {
            score = Int(Float(score) * 8 / 10) + Int(money / YIYI * 2 / 10)
        }
        self.score = score
    }
    static let blacklist = ["富时罗素概念股","深股通","MSCI概念","转融券标的","标普道琼斯A股",
                            "沪股通","MSCI预期","参股新三板","融资融券","独角兽概念",
                            "证金持股"]
    public static func isBlackList(title: String) -> Bool {
        return blacklist.contains(title)
    }
}

