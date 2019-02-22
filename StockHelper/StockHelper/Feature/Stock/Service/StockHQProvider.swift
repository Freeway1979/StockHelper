//
//  StockHQProvider.swift
//  HelloWorldSwift
//
//  Created by andyli2 on 2019/2/22.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

class StockHQProvider {
    static var cache:[String:StockHQList] = [:]
    
    public static func getStockDayHQ(by code:String) {
        //Check cache first
//        var modelObject:StockHQList? = cache[code]
//        if modelObject != nil {
//            //Check date
//        }
        let cstar:StockHQAPI.CStar = StockHQAPI.CStar.HQ(code: code, period: StockHQAPI.CStar.StockPeriod.Day)
        let url = cstar.url
        let data = try? Data(contentsOf: URL(string: url)!)
        let jsonStr = cstar.parseData(data: data!)
        let jsonDecoder = JSONDecoder()
        let modelObject:StockHQList? = try? jsonDecoder.decode(StockHQList.self, from: jsonStr.data(using: String.Encoding.utf8)!)
        //Cache
        cache[code] = modelObject
        
        //print("\(String(describing: modelObject?.predictMA5(predictedChange: 10)))")
        
    }
}
