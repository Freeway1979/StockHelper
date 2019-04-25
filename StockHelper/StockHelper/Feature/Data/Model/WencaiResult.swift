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
    var money:NSNumber //板块资金量
    var zhangting:Int //板块涨停数
    var zhangfu:NSNumber //板块涨幅
    var score: Float
}

struct WenCaiBlockTops {
    var blocks:[WenCaiBlockStat] = []
    var query:String
    var date:String
    
    mutating func fillDataFromDictionary(dict:Dictionary<String, Any>) {
        self.query = dict["query"] as! String
        let rs = dict["result"] as! [[Any]]
        let titles = dict["title"] as! [String]
        let s = titles[3]
        self.date = String(s.suffix(10))
        var count = 30
        for item in rs {
            print(item)
            if (count > 0) {
                let block = WenCaiBlockStat(title: item[1] as! String, money: item[5] as! NSNumber, zhangting: 0, zhangfu: item[3] as! NSNumber, score: 0)
                self.blocks.append(block)
            } else {
                break
            }
            count = count - 1
        }
        print(self.query)
    }
}
