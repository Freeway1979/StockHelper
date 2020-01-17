//
//  LHBShuDataService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/12/14.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class LHBShuDataService: StockDataService {
    convenience init() {
        self.init(date: Date().formatWencaiDateString(), keywords: "120日内的龙虎榜数排序", title: "120日内的龙虎榜数排序")
    }
    override func serverItemToModel(item: [Any]) -> Any {
        let code = item[0] as! String
        let lhb = Utils.getNumberString(serverData: item[4])
        let stock = LHBShuStock(code: String(code.prefix(6)))
        stock.lhb = lhb
        return stock
    }
}
