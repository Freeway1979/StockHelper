//
//  ZhanggTingShuDataService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/6.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class ZhangTingShuDataService: StockDataService {
    convenience init() {
        self.init(date: Date().formatWencaiDateString(), keywords: "120日内的涨停数排序", title: "120日内的涨停数排序")
    }
    override func handleWenCaiStocksResponse(date:String,dict:Dictionary<String, Any>) -> [Any] {
        print("\(date) ZhangTingShuDataService handleWenCaiStocksResponse")
        let rs = dict["result"] as! [[Any]]
        print(rs.count)
        var stocks:[ZhangTingShuStock] = []
        for item in rs {
            let code = item[0] as! String
            let zt = Utils.getNumberString(serverData: item[4])
            let stock = ZhangTingShuStock(code: String(code.prefix(6)))
            stock.zt = zt
            stocks.append(stock)
        }
        return stocks
    }
    
    override func handlePaginationResponse(date:String,json:String,dict:Dictionary<String, Any>) {
        let stocks:[ZhangTingShuStock] = self.handleWenCaiStocksResponse(date:date, dict: dict) as! [ZhangTingShuStock]
        if self.onComplete != nil {
            self.onComplete!(stocks)
        }
    }
}
