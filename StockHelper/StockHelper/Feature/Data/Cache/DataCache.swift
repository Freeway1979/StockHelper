//
//  DataCache.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/4/21.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class DataCache {
    // *******************自定义标签***********************
    private static var stockExtraMap:[String:StockExtra] = [:]
    public static func loadStockExtras() {
        let key = UserDefaultKeys.Stock.tags
        do {
            let data = Utils.loadPersistantData(key: key)
            if (data != nil)
            {
                let rs = try JSONDecoder().decode([String:StockExtra].self, from: (data! as? Data)!)
                stockExtraMap = rs
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public static func saveStockExtras() {
        let key = UserDefaultKeys.Stock.tags
        do {
            let data = try JSONEncoder().encode(stockExtraMap)
            Utils.savePersistantData(key: key, data: data)
        } catch {
            print(error.localizedDescription)
        }
    }
    public static func getStockExtra(code:String) -> StockExtra? {
        return stockExtraMap[code]
    }
    public static func setStockExtra(code:String, extra:StockExtra) {
       stockExtraMap[code] = extra
       //Sync to iCloud
       saveStockExtras()
    }

    // *******************历史标签***********************
    private static let maxHistoryItem:Int = 20
    private static var historyTags:[String] = []
    public static func addHistoryTag(tag:String) {
        if historyTags.contains(tag) {
            return
        }
        historyTags.insert(tag, at: 0)
        if historyTags.count > maxHistoryItem {
            historyTags.removeLast()
        }
        // Save
        saveHistoryTags()
    }
    public static func getHistoryTags() -> [String] {
        return Array(historyTags.prefix(maxHistoryItem))
    }
    public static func saveHistoryTags() {
        let key = UserDefaultKeys.Stock.historyTags
        Utils.savePersistantData(key: key, data: historyTags, iCloud: false)
    }
    public static func loadHistoryTags() {
        let key = UserDefaultKeys.Stock.historyTags
        let data = Utils.loadPersistantData(key: key)
        if (data != nil)
        {
            historyTags = data as! [String]
        }
    }
    // *******************板块周期表***********************
    public static var blockTops:[String:[WenCaiBlockStat]]? = [:]
    //市场总龙头
    public static var marketDragon:ZhangTingStock?
    //空间龙头
    public static var gaoduDragon:ZhangTingStock?
    //最后有效日期
    public static var lastDate:String?
    //盈利
    public static var yingliStocks:[YingLiStock] = []
    //扭亏
    public static var niukuiStocks:[NiuKuiStock] = []
    //解禁
    public static var jiejinStocks:[JieJinStock] = []
    //120日涨停数
    public static var ztsStocks:[ZhangTingShuStock] = []
    //每日的涨停股票
    public static var ztStocks:[ZhangTingStocks] = []
    
    public static func reset() {
        blockTops?.removeAll()
        ztStocks.removeAll()
    }
    
    public static func getZhangTingStocks(by date:String) -> ZhangTingStocks? {
       return ztStocks.first { (s) -> Bool in
           return s.date == date
        }
    }
    
    public static func getZhangTingStocks(date:String, gn:String) -> [ZhangTingStock] {
        guard let stocksWithDate = getZhangTingStocks(by: date) else { return [] }
        let stocks = stocksWithDate.stocks.filter { (stock) -> Bool in
           let s = StockUtils.getStock(by: stock.code)
            if s.gnList.contains(gn) {
                return true
            }
            return false
        }
        return stocks
    }
    
    public static func getZhangTingStock(date:String, code:String) -> ZhangTingStock? {
        guard let stocksWithDate = getZhangTingStocks(by: date) else { return nil }
        let stock = stocksWithDate.stocks.first { (stock) -> Bool in
            return stock.code == code
        }
        return stock
    }
    
//    public static func buildLianXuZhangTingShu(dates:[String]) {
//        let theDates = dates.sorted { (lhs, rhs) -> Bool in
//            return lhs.compare(rhs) == .orderedAscending
//        }
//        var lastDate:String?
//        theDates.forEach { (date) in
//            let ztstocksWithDate:ZhangTingStocks = getZhangTingStocks(by: date)!
//            var lastZtstocksWithDate:ZhangTingStocks?
//            if lastDate != nil {
//                lastZtstocksWithDate = getZhangTingStocks(by: lastDate!)
//            }
//            ztstocksWithDate.stocks.forEach({ (stock) in
//                if lastZtstocksWithDate == nil {
//                    stock.zhangting = 1
//                } else {
//                   let lastStock = lastZtstocksWithDate?.stocks.first(where: { (ztstock) -> Bool in
//                        ztstock.code == stock.code
//                    })
//                    if lastStock != nil {
//                        stock.zhangting = lastStock!.zhangting + 1
//                    }
//                }
//            })
//            ztstocksWithDate.stocks.sort { (lhs, rhs) -> Bool in
//                return lhs.zhangting > rhs.zhangting
//            }
//            lastDate = date
//        }
//    }

    public static func getLastDate() -> String {
        if DataCache.lastDate != nil {
            return DataCache.lastDate!
        }
        var i = 0
        let today = Date()
        while i < 30 {
            let date = Date(timeInterval: -Date.ONEDAY * Double(i), since: today)
            if (date.isWorkingDay) {
                return date.formatWencaiDateString()
            }
            i = i + 1
        }
        return Date().formatWencaiDateString()
    }

    // 连板龙(高度板)
    public static func getMarketDragonStock(date:String? = nil) -> ZhangTingStock? {
        if date == nil { //Total
            guard let stocksWithDate = ztStocks.last else { return nil }
            return stocksWithDate.stocks.first
        }
        guard let stocksWithDate = getZhangTingStocks(by: date!) else { return nil }
        return stocksWithDate.stocks.first
    }

    // 市场总龙头
    public static func getMarketDragonStocks(dates:[String]) -> [ZhangTingStock]? {
        var rs:[String:Int] = [:]
        dates.forEach { (date) in
            guard let stocksWithDate = getZhangTingStocks(by: date) else { return }
            stocksWithDate.stocks.forEach({ (stock) in
                let code = stock.code
                if rs[code] == nil {
                    rs[code] = 1
                } else {
                    rs[code] = 1 + rs[code]!
                }
            })
        }
        var topList:[ZhangTingStock] = []
        for (k,v) in (Array(rs).sorted {$0.1 > $1.1}) {
            topList.append(ZhangTingStock(code: k, zhangting: v))
        }
        if topList.count >= 3 {
            return Array(topList.prefix(3))
        }
        return topList
    }
    
    // 板块小龙头
    public static func getDragonStocks(dates:[String], gn:String) -> [ZhangTingStock] {
        var rs:[String:Int] = [:]
        dates.forEach { (date) in
            guard let stocksWithDate = getZhangTingStocks(by: date) else { return }
            stocksWithDate.stocks.forEach({ (stock) in
                let code = stock.code
                let s = StockUtils.getStock(by: code)
                if s.gnList.contains(gn) {
                    if rs[code] == nil {
                        rs[code] = 1
                    } else {
                        rs[code] = 1 + rs[code]!
                    }
                }
            })
        }
        var topList:[ZhangTingStock] = []
        for (k,v) in (Array(rs).sorted {$0.1 > $1.1}) {
            topList.append(ZhangTingStock(code: k, zhangting: v))
        }
        if topList.count >= 3 {
            return Array(topList.prefix(3))
        }
        return topList
    }
    
    public static func getTopBlockNamesForStock(stock:Stock) -> [String] {
        // 看看是否在前十大热门板块中
        let names:[String] = DataCache.getTopBlockNames()
        var blocks:[String] = []
        var count = 0
        names.forEach({ name in
            if (count < 10) {
                if stock.gnList.contains(name) {
                    blocks.append(name)
                }
                count = count + 1
            }
        })
        return blocks
    }
    
    public static func getTopBlockNames() -> [String] {
        var blockScoreDic:[String:Int] = [:]
        self.blockTops?.forEach({ (item) in
            let (_, value) = item
            value.forEach({ (block) in
                var vv = blockScoreDic[block.title]
                if (vv == nil) {
                    vv = 0
                }
                vv = vv! + block.score
                blockScoreDic[block.title] = vv
            })
        })
        
        var topList:[String] = []
        for (k,v) in (Array(blockScoreDic).sorted {$0.1 > $1.1}) {
//            print("\(k):\(v)")
            topList.append(k)
        }
        return topList
    }
    
    public static func getBlocksByDate(date:String) -> [WenCaiBlockStat]? {
        if (blockTops == nil) {
            blockTops = [:]
        }
        var rs = blockTops?[date]
        if rs == nil {
            rs = []
            blockTops?[date] = rs
        }
        return rs
    }
    
    public static func setBlocksByDate(date:String, blocks:[WenCaiBlockStat]) {
        if (blockTops == nil) {
            blockTops = [:]
        }
        var theBlocks = blocks
        if blocks.count > 20 {
            theBlocks = Array(blocks[0...19])
        }
        blockTops?[date] = theBlocks;
    }
    
    public static func saveToDB() {
        if blockTops?.count == 0 {
            return
        }
        let encoder = JSONEncoder()
        let data = try! encoder.encode(blockTops)
        StockDBProvider.saveBlockLifeCycleData(data: data)
        print("Save block tops to local and iCloud")
        //每日涨停
        StockDBProvider.saveZhangTingStocks(stocks: ztStocks)
        if DataCache.lastDate != nil {
            Utils.savePersistantData(key: UserDefaultKeys.Block.lastDate, data: DataCache.lastDate!)
        }
    }
    
    public static func loadFromDB() {
       let data = StockDBProvider.loadBlockLifeCycleData()
        if (data != nil) {
            let decoder = JSONDecoder()
            let dict = try! decoder.decode([String:[WenCaiBlockStat]].self, from: data!)
            blockTops?.removeAll()
            blockTops = dict
            print("Load block tops from local and iCloud")
        }
        //每日涨停
        ztStocks = StockDBProvider.loadZhangTingStocks()
        let date:String? = Utils.loadPersistantData(key: UserDefaultKeys.Block.lastDate) as? String
        DataCache.lastDate = date
    }
    
    public static func printData() {
        blockTops?.forEach({ (item) in
            let (key, value) = item
            print(key,value);
        })
    }
}
