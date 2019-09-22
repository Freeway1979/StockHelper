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
    override func serverItemToModel(item: [Any]) -> Any {
        let code = item[0] as! String
        let zt = Utils.getNumberString(serverData: item[4])
        let stock = ZhangTingShuStock(code: String(code.prefix(6)))
        stock.zt = zt
        return stock
    }
}
