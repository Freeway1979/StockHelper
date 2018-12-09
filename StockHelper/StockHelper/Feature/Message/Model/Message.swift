//
//  Message.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/9/19.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import Foundation

enum MessageLevel:String {
    case High = "重要"
    case Normal = "一般"
    case Low = "次要"
}

class Message {
    init(subject: String) {
        self.subject = subject
    }
    //主题
    var subject:String = "";
    //等级
    var level:MessageLevel = .Normal;
    //来源
    var source:String = "";
    //分类
    var category:String = "";
    //修改时间
    var time:Date?;
    //利好
    var positiveMemo:String = "";
    //利空
    var negativeMemo:String = "";
    //利好板块
    var positiveBlocks:[StockBlock] = [];
    //利空板块
    var negativeBlocks:[StockBlock] = [];
    //利好股票
    var positiveStocks:[Stock] = []
    //利空股票
    var negativeStocks:[Stock] = []
}

