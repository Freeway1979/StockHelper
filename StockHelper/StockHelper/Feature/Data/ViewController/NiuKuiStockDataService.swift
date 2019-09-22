//
//  YingLiStockDataService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/4.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class NiuKuiStockDataService: StockDataService {
    convenience init() {
        self.init(date: Date().formatWencaiDateString(), keywords: "扭亏为盈 流通市值", title: "扭亏为盈")
    }
    
    override func serverItemToModel(item: [Any]) -> Any {
        let code = item[0] as! String
        let tradeValue = Utils.getNumberString(serverData: item[5])
        let yingliValue = Utils.getNumberString(serverData: item[6])
        let lastYingliValue = Utils.getNumberString(serverData: item[7])
        let yingliRise = Utils.getNumberString(serverData: item[8])
        let yugaoDate = Utils.getNumberString(serverData: item[9])
        let stock = NiuKuiStock(code: String(code.prefix(6)))
        stock.tradeValue = tradeValue
        stock.yingliValue = yingliValue
        stock.lastYingliValue = lastYingliValue
        stock.yingliRise = yingliRise
        stock.yugaoDate = yugaoDate
        return stock
    }
}
