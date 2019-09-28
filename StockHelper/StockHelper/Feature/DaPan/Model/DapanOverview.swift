//
//  DapanOverview.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/27.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class DapanOverview {
    
    var hqList: [StockDayHQ] = []
    
    var warning:String?
    
    static let sharedInstance = DapanOverview()

    private init() {

    }

    
    func hasDangerousKLines() -> Bool {
        return false
    }
    
    func hasGreatKLines() -> Bool {
        return false
    }
    
    var overviewTex: String = ""
    
    func parseData() {
        var text = ""
        if self.isDuoTou {
            text = "多头行情 "
            sugguestCangWei = "60%以上"
            dapanStatus = "强势"
            sugguestAction = "持股"
        } else if self.isKoutou {
            text = "空头行情 "
            warning = "空头"
            sugguestCangWei = "20%以下"
            dapanStatus = "弱势"
            sugguestAction = "持币"
        }
        let third = hqList[2]
        if third.isAboveMA5 && self.isDoubleBelowMA5 {
            if third.isDuoTou {
                text = "\(text)发生向下转势 "
                warning = "转空"
                sugguestCangWei = "30%以下"
                dapanStatus = "转弱"
                sugguestAction = "减仓"
            } else {
                text = "\(text)连续转弱 "
                warning = "转弱"
                sugguestCangWei = "30%以下"
                dapanStatus = "转弱"
                sugguestAction = "减仓"
            }
        }
        if third.isBelowMA5 && self.isDoubleAboveMA5 {
            if third.isKouTou {
               text = "\(text)发生向上转势 "
               sugguestCangWei = "30%以上"
                dapanStatus = "转强"
                sugguestAction = "加仓"
            } else {
               text = "\(text)连续转强 "
               sugguestCangWei = "30%以上"
               dapanStatus = "转强"
               sugguestAction = "加仓"
            }
        }
        let first = hqList[0]
        if !self.isKoutou && first.isBelowMA5 && first.isBelowMA10 && first.isBelowMA20 {
            text = "\(text)疑似空头走势 "
            warning = "转空"
            sugguestCangWei = "30%以下"
            dapanStatus = "转弱"
            sugguestAction = "减仓"
        }
        if self.isDuoTou && self.isDoubleBelowMA5In3Days {
            text = "\(text)3日2次跌破5日线 "
            warning = "谨慎转空"
            sugguestCangWei = "30%以下"
            dapanStatus = "转弱"
            sugguestAction = "减仓"
        }
        if self.isKoutou && self.isDoubleAboveMA5In3Days {
            text = "\(text)3日2次站上5日线 "
            warning = "谨慎转多"
            sugguestCangWei = "30%以下"
            dapanStatus = "转强"
            sugguestAction = "加仓"
        }
        overviewTex = text
    }
    
    var sugguestAction:String = "持股"
    
    var sugguestCangWei:String = "50%"
    
    var dapanStatus:String = "弱势"
    
    var dapanStatusBadge:String? {
       if warning != nil {
          return warning
       }
       //
       return nil
    }
    
    var chaoduanQingXu: ChaoDuanQingXu = .QingXuXiuFu
    var keepWarning:Bool = false
    
    var isKoutou: Bool {
        let first:StockDayHQ = hqList.first!
        let second:StockDayHQ = hqList[1]
        return first.isKouTou && second.isKouTou
    }
    
    var isDuoTou: Bool {
         let first:StockDayHQ = hqList.first!
         let second:StockDayHQ = hqList[1]
         return first.isDuoTou && second.isDuoTou
    }
    
    // 3天2次站上5日线
    var isDoubleAboveMA5In3Days:Bool {
        var count = 0
        for index in 0...2 {
            let hq:StockDayHQ = hqList[index]
            if hq.isAboveMA5 {
                count = count + 1
            }
        }
        return count >= 2
    }
    
    // 3天2次跌破5日线
    var isDoubleBelowMA5In3Days:Bool {
        var count = 0
        for index in 0...2 {
            let hq:StockDayHQ = hqList[index]
            if hq.isBelowMA5 {
                count = count + 1
            }
        }
        return count >= 2
    }
    
    //连续2天在5日线下方
    var isDoubleBelowMA5:Bool {
        let first:StockDayHQ = hqList.first!
        let second:StockDayHQ = hqList[1]
        return first.isBelowMA5 && second.isBelowMA5
    }
    //连续2天在5日线上方
    var isDoubleAboveMA5:Bool {
        let first:StockDayHQ = hqList.first!
        let second:StockDayHQ = hqList[1]
        return first.isAboveMA5 && second.isAboveMA5
    }
    
    public func getHQListFromServer(code:String,startDate:String, endDate:String) -> [StockDayHQ] {
        if hqList.count > 0 && Date().isMarketClosed {
            return hqList
        }
        let csvData = try? String(contentsOf: URL(string: "http://quotes.money.163.com/service/chddata.html?code=0000001&start=\(startDate)&end=\(endDate)&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;VOTURNOVER;VATURNOVER")!, encoding: String.gbkEncoding)
        if csvData != nil {
            let list:[String] = csvData!.components(separatedBy: "\r\n")
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
            self.hqList = hqList
            self.parseData()
            return hqList
        }
        return []
    }
}
