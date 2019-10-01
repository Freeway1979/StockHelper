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
//        self.handler = { (date, json, dict) in
//            
//        }
    }
    
    override func serverItemToModel(item:[Any]) -> Any {
        let code = item[0] as! String
        let name = item[1] as! String
        let tradeValue = Utils.getNumberString(serverData: item[6])
        let gn:String? = item[4] as? String
        let stock = Stock(code: String(code.prefix(6)), name: name)
        stock.tradeValue = tradeValue
        stock.gnListStr = gn ?? ""
        return stock
    }
    
    override func buildPaginationService() -> DataService {
        let dataService = DataService(date: self.date,keywords: "cacheToken", title: "StockList")
        dataService.perpage = 5000
        return dataService
    }

}
