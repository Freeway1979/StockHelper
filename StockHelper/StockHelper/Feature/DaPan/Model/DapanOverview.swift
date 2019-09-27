//
//  DapanOverview.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/27.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class DapanOverview {
    static var hqList: [StockDayHQ] = []
    func hasDangerousKLines() -> Bool {
        return false
    }
    
    func hasGreatKLines() -> Bool {
        return false
    }
    
    var overviewTex: String {
        return "大盘安详"
    }
    
    var sugguestAction:String {
        return "持股"
    }
    
    var sugguestCangWei:String {
        return "50%"
    }
    
    var dapanStatus:String {
        return "弱势"
    }
    
    var dapanStatusBadge:String? {
        return "危险"
    }
    
    var keepWarning:Bool = false
    
    func parseData() -> Any {
        
        return (1)
    }
    
    public static func getHQListFromServer(code:String,startDate:String, endDate:String) -> [StockDayHQ] {
        if DapanOverview.hqList.count > 0 && Date().isMarketClosed {
            return DapanOverview.hqList
        }
        let csvData = try? String(contentsOf: URL(string: "http://quotes.money.163.com/service/chddata.html?code=0000001&start=20190219&end=20190927&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;VOTURNOVER;VATURNOVER")!, encoding: String.gbkEncoding)
        if csvData != nil {
            let list:[String] = csvData!.components(separatedBy: "\r\n")
            print(list)
            var datas:[[String]] = []
            let count = list.count
            for index in 1...count-1 {
//                日期 0,股票代码 1,名称 2,收盘价 3,最高价 4,最低价 5,开盘价 6,前收盘 7,涨跌额 8,涨跌幅 9,成交量 10,成交金额 11
                let item = list[index]
                let arr:[String] = item.components(separatedBy: ",")
                if arr.count > 11 {
                    var data:[String] = []
                    data.append(arr[0]) //Date
                    data.append(arr[6]) //Open
                    data.append(arr[4]) //High
                    data.append(arr[5]) //Low
                    data.append(arr[3]) //Close
                    data.append(arr[8])
                    data.append(arr[9])
                    data.append(arr[10])
                    data.append(arr[11])
                    datas.append(data)
                }
            }
            var hqListData:StockHQList = StockHQList(type: "Day", code: code, datas: datas)
            let hqList: [StockDayHQ] = hqListData.hqList
            hqListData.datas.removeAll()
            DapanOverview.hqList = hqList
            return hqList
        }
        return []
    }
}
