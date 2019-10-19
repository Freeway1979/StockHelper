//
//  ZhangTingDataService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/22.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class ZhangTingDataService: StockDataService {
    convenience init(date:String) {
        self.init(date: date, keywords: "\(date)涨停且上市天数大于25天且非ST 所属概念 前500", title: "\(date)涨停且上市天数大于25天且非ST 所属概念 前500")
    }
    
    override func serverItemToModel(item: [Any]) -> Any {
        let zt = Utils.getNumber(serverData:item[16]).intValue
        let code = item[0] as! String
        let name = item[1] as! String
        let stock = ZhangTingStock(code: String(code.prefix(6)), zhangting: zt)
        stock.name = name
        stock.gnListStr = item[10] as! String
        stock.ztBanType = item[12] as! String
        stock.ztFirstTime = item[13] as! String
        stock.ztLastTime = item[14] as! String
        stock.ztYuanYin = item[17] as! String
        stock.ztBiils = Utils.getNumberString(serverData: item[18])
        stock.ztMoney = Utils.getNumberString(serverData: item[19])
        stock.ztRatioBills = Utils.getNumberString(serverData: item[20])
        stock.ztRatioMoney = Utils.getNumberString(serverData: item[21])
        stock.ztKaiBan = Utils.getNumber(serverData: item[22]).intValue
        return stock
    }
    
}
