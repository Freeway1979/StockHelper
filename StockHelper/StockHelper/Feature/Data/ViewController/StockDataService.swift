//
//  StockDataService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/3.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class StockDataService: DataService {
    override init(date: String, keywords: String, title: String) {
        super.init(date: date, keywords: keywords, title: title)
        self.handler = { (date, json, dict) in
            
        }
        self.paginationService = self.buildPaginationService()
    }
    
    private func buildPaginationService() -> DataService {
        let today = Date().formatWencaiDateString()
        let dataService = DataService(date: today,keywords: "cacheToken", title: "StockList")
        dataService.perpage = 5000
        dataService.handler = { [unowned self] (date, json, dict) in
            self.handlePaginationResponse(date: date, json: json, dict: dict)
        }
        return dataService
    }
    
    override func handleResponse(date:String,json:String,dict:Dictionary<String, Any>) {
        
    }
    
    private func handleWenCaiStocksResponse(date:String,dict:Dictionary<String, Any>) -> [Stock] {
        print("\(date) handleWenCaiStocksResponse")
        let rs = dict["result"] as! [[Any]]
        print(rs.count)
        var stocks:[Stock] = []
        for item in rs {
            let zt = 0
            //            if (item[6] is NSNumber) {
            //                zt = (item[6] as! NSNumber).intValue
            //            }
            let code = item[0] as! String
            let name = item[1] as! String
            let tradeValue = item[6] as? NSNumber
            let gn:String? = item[4] as? String
            let stock = Stock(code: String(code.prefix(6)), name: name)
            stock.tradeValue = tradeValue != nil ? tradeValue!.stringValue : "0"
            stock.zt = zt
            stock.gnListStr = gn ?? ""
            stocks.append(stock)
        }
        return stocks
    }
    
    func handlePaginationResponse(date:String,json:String,dict:Dictionary<String, Any>) {
        let stocks:[Stock] = self.handleWenCaiStocksResponse(date:date, dict: dict)
        if self.onComplete != nil {
            self.onComplete!(stocks)
        }
    }
}
