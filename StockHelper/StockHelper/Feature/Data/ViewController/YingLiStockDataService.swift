//
//  YingLiStockDataService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/4.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class YingLiStockDataService: StockDataService {
    override func handleWenCaiStocksResponse(date:String,dict:Dictionary<String, Any>) -> [Any] {
        print("\(date) handleWenCaiStocksResponse")
        let rs = dict["result"] as! [[Any]]
        print(rs.count)
        var stocks:[YingLiStock] = []
        for item in rs {
            let code = item[0] as! String
            let tradeValue = Utils.getNumberString(serverData: item[7])
            let yingliValue = Utils.getNumberString(serverData: item[4])
            let yingshouValue = Utils.getNumberString(serverData: item[5])
            let yingliRise = Utils.getNumberString(serverData: item[6])
            let stock = YingLiStock(code: String(code.prefix(6)))
            stock.tradeValue = tradeValue
            stock.yingliValue = yingliValue
            stock.yingshouValue = yingshouValue
            stock.yingliRise = yingliRise
            stocks.append(stock)
        }
        return stocks
    }
    
    override func handlePaginationResponse(date:String,json:String,dict:Dictionary<String, Any>) {
        let stocks:[YingLiStock] = self.handleWenCaiStocksResponse(date:date, dict: dict) as! [YingLiStock]
        if self.onComplete != nil {
            self.onComplete!(stocks)
        }
    }
}
