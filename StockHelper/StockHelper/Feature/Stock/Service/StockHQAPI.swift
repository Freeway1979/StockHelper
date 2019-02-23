//
//  StockHQAPI.swift
//  HelloWorldSwift
//
//  Created by andyli2 on 2019/2/22.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

enum StockHQAPI {
    enum CStar {
        enum StockPeriod:Int {
            case OneMinute = 1
            case FiveMinutes = 3
            case ThirtyMinutes = 5
            case Day = 6
            case Week = 7
            case Month = 8
        }
        case HQ(code:String,period:StockPeriod)
        
        var url:String {
            switch self {
            case .HQ(let code,let period):
                let codeType:Int = code.starts(with: "6") ? 1 : 2
                let url = "http://cq.ssajax.cn/interact/getTradedata.ashx?pic=qlpic_\(code)_\(codeType)_\(period.rawValue)"
                return url
            }
        }
        func parseData(data:Data) -> String {
            switch self {
            case .HQ(_,_):
                let str:String = String(gbkData: data)!
                let r = str.range(of: "var tradeData_qlpic_")
                let start = str.index((r?.upperBound)!, offsetBy: "000001_1_1=".count)
                let end = str.index(str.endIndex, offsetBy: -2)
                let jsonStr = String(str[start...end]).replacingOccurrences(of: "'", with: "\"")
                return jsonStr
            }
        }
    }
}
