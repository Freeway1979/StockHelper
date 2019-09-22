//
//  YingLiStockDataService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/4.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class YingLiStockDataService: StockDataService {
    convenience init() {
        self.init(date: Date().formatWencaiDateString(), keywords: "盈利超2000万", title: "盈利超2000万")
    }
    
    override func serverItemToModel(item: [Any]) -> Any {
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
        return stock
    }
}
