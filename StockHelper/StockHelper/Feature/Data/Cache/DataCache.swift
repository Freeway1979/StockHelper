//
//  DataCache.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/4/21.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class DataCache {
    public static var blockTops:[String:[WenCaiBlockStat]]? = [:]
    
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
    
    // 连板龙(高度板)
    public static func getMarketDragonStock(date:String) -> ZhangTingStock? {
        guard let stocksWithDate = getZhangTingStocks(by: date) else { return nil }
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
            print("\(k):\(v)")
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
    }
    
    public static func printData() {
        blockTops?.forEach({ (item) in
            let (key, value) = item
            print(key,value);
        })
    }
}
