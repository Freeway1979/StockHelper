//
//  JieJinStockDataService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/6.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

// 解禁
class JieJinStockDataService: StockDataService {
    convenience init() {
        self.init(date: Date().formatWencaiDateString(), keywords: "0日后解禁", title: "0日后解禁")
    }
    override func handleWenCaiStocksResponse(date:String,dict:Dictionary<String, Any>) -> [Any] {
        print("\(date) JieJinStockDataService handleWenCaiStocksResponse")
        let rs = dict["result"] as! [[Any]]
        print(rs.count)
        var stocks:[JieJinStock] = []
        for item in rs {
            let code = item[0] as! String
            let date = Utils.getNumberString(serverData: item[4])
            let ratio = Utils.getNumberString(serverData: item[6])
            let money = Utils.getNumberString(serverData: item[7])
            let type = Utils.getNumberString(serverData: item[8])
            let price = Utils.getNumberString(serverData: item[10])
            let stock = JieJinStock(code: String(code.prefix(6)))
            stock.date = date
            stock.ratio = ratio
            stock.money = money
            stock.type = type
            stock.price = price
            stocks.append(stock)
        }
        return stocks
    }
    
    override func handlePaginationResponse(date:String,json:String,dict:Dictionary<String, Any>) {
        let stocks:[JieJinStock] = self.handleWenCaiStocksResponse(date:date, dict: dict) as! [JieJinStock]
        if self.onComplete != nil {
            self.onComplete!(stocks)
        }
    }
}

