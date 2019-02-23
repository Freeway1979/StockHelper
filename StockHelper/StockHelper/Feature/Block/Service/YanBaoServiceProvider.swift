//
//  YanBaoServiceProvider.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/2/16.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation


import Foundation
import Moya

class YanBaoServiceProvider {
    
    public static var yanBaos:[YanBao] = []
    
    /// 获取研报清单
    ///
    /// - Parameter callback: <#callback description#>
    public static func getYanBaoList(byForce:Bool = false,
                                    callback:@escaping ([YanBao]) -> Void ) {
        if (!byForce) {
            // Get data from memory cache
            if YanBaoServiceProvider.yanBaos.count > 0 {
                callback(YanBaoServiceProvider.yanBaos)
                print("Getting stock data from memory cache")
                return
            }
            // Get data from local
//            if let data = StockDBProvider.loadBasicStocks() {
//                let stocks = parseJSONStringToStocks(jsonString: data)
//                let pinyinMap = StockDBProvider.loadStockPinYin()
//                for item in stocks {
//                    item.pinyin = pinyinMap[item.code] ?? ""
//                }
//                StockServiceProvider.stocks = stocks
//                buildStocksMap()
//                callback(stocks)
//                print("Getting stock data from local")
//                return;
//            }
        }
        // Get data from remote
        let provider = MoyaProvider<StockService>()
        provider.request(StockService.getYanBaoShe) { result in
            // do something with the result (read on for more details)
            if case let .success(response) = result {
                let jsonString = try? response.mapString()
                if jsonString != nil {
                    //StockDBProvider.saveBasicStocks(data: jsonString!)
                    let _yanbaos:[YanBao] = (jsonString?.json2Objects())!
                    YanBaoServiceProvider.yanBaos = _yanbaos
                    callback(yanBaos)
                    print("Getting yanbao data from remote")
                }
            }
        }
    }
    
}
