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
        if self.isCuoRouXian {
            text = "\(text)搓揉线,可能变盘 "
        }
        if self.isFanCuoRouXian {
            text = "\(text)反搓揉线,可能变盘 "
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
    
    //搓揉线
    var isCuoRouXian:Bool {
        let first:StockDayHQ = hqList.first!
        let second:StockDayHQ = hqList[1]
        return second.isShangYingXian && first.isXiaYingXian
    }
    //反搓揉线
    var isFanCuoRouXian:Bool {
        let first:StockDayHQ = hqList.first!
        let second:StockDayHQ = hqList[1]
        return second.isXiaYingXian && first.isShangYingXian
    }
    
    public func getHQListFromServer(code:String,startDate:String, endDate:String) -> [StockDayHQ] {
        if hqList.count > 0 && Date().isMarketClosed {
            return hqList
        }
        let randomTime = Float.random(in: Range<Float>(uncheckedBounds: (lower: 0, upper: 1)))
        let url = WebSite.DapanHistory.replacingOccurrences(of: "TIME", with: "\(randomTime)")
        
        var rs = try? String(contentsOf: URL(string: url)!, encoding: String.gbkEncoding)
        rs = rs?.replacingOccurrences(of: "historySearchHandler([", with: "")
        rs = rs?.replacingOccurrences(of: "])\n", with: "")
        let jsonData:Data = rs!.data(using: .utf8)!
        let dict:Dictionary<String, Any>? = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! Dictionary<String, Any>
        if dict != nil {
            let list:[[String]] = dict!["hq"] as! [[String]]
            var hqListData:StockHQList = StockHQList(type: "Day", code: code, datas: list)
            let hqList: [StockDayHQ] = hqListData.hqList
            hqListData.datas.removeAll()
            self.hqList = hqList
            self.parseData()
            return hqList
        }
        return []
    }
}
