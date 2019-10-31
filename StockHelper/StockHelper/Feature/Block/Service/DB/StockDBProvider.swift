//
//  StockDBProvider.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/5.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

struct UserDefaultKeys {
    struct Stock {
        static let basicStocks = "BasicStocks"
        static let basicStocksPinYin = "BasicStocksPinYin"
        static let basicStocksUpdateTime = "BasicStocksUpdateTime"
        static let hotStocks = "HotStocks"
        static let importantStocks = "ImportantStocks"
        static let yingliStocks = "YingLiStocks"
        static let niukuiStocks = "NiuKuiStocks"
        static let zhangtingshuStock = "ZhangTingShuStock"
        static let jinjinStock = "JinJinStock"
        static let zhangtingStock = "ZhangTingStock"
        static let tags = "Tags"
        static let historyTags = "HistoryTags"
    }
    struct Block {
        static let basicBlocks = "BasicBlocks"
        static let basicBlocksPinYin = "BasicBlocksPinYin"
        static let basicBlocksUpdateTime = "BasicStocksUpdateTime"
        static let hotBlocks = "HotBlocks"
        static let importantBlocks = "ImportantStocks"
        static let blokLifeCycle = "BlokLifeCycle"
        static let lastDate = "LastDate"
        static let gaoduDragon = "GaoduDragon"
        static let marketDragon = "MarketDragon"
    }
}

class StockDBProvider {
    
    
    // Mark :Basic
    public static func saveBasicBlocks(blocks:[Block]) {
        StockUtils.saveData(data: blocks, key: UserDefaultKeys.Block.basicBlocks)
    }
    
    public static func loadBasicBlocks() -> [Block] {
        return StockUtils.loadData(key: UserDefaultKeys.Block.basicBlocks)
    }
    
    public static func saveBasicStocks(stocks:[Stock]) {
      StockUtils.saveData(data: stocks, key: UserDefaultKeys.Stock.basicStocks)
    }
    
    public static func loadBasicStocks() -> [Stock] {
        return StockUtils.loadData(key: UserDefaultKeys.Stock.basicStocks)
    }
    // 盈利大于2000万
    public static func saveYingLiStocks(stocks:[YingLiStock]) {
        StockUtils.saveData(data: stocks, key: UserDefaultKeys.Stock.yingliStocks)
        DataCache.yingliStocks = stocks
    }
    
    public static func loadYingLiStocks() -> [YingLiStock] {
        let stocks:[YingLiStock] = StockUtils.loadData(key: UserDefaultKeys.Stock.yingliStocks)
        DataCache.yingliStocks = stocks
        return stocks
    }
    
    // 扭亏为盈（预告）
    public static func saveNiuKuiStocks(stocks:[NiuKuiStock]) {
        StockUtils.saveData(data: stocks, key: UserDefaultKeys.Stock.niukuiStocks)
        DataCache.niukuiStocks = stocks
    }
    
    public static func loadNiuKuiStocks() -> [NiuKuiStock] {
        let stocks:[NiuKuiStock] = StockUtils.loadData(key: UserDefaultKeys.Stock.niukuiStocks)
        DataCache.niukuiStocks = stocks
        return stocks
    }
    
    // 120日内涨停数
    public static func saveZhangTingShuStocks(stocks:[ZhangTingShuStock]) {
        StockUtils.saveData(data: stocks, key: UserDefaultKeys.Stock.zhangtingshuStock)
        DataCache.ztsStocks = stocks
    }
    
    public static func loadZhangTingShuStocks() -> [ZhangTingShuStock] {
        let stocks:[ZhangTingShuStock] = StockUtils.loadData(key: UserDefaultKeys.Stock.zhangtingshuStock)
        DataCache.ztsStocks = stocks
        return stocks
    }
    
    // 将要解禁
    public static func saveJieJinStockStocks(stocks:[JieJinStock]) {
        StockUtils.saveData(data: stocks, key: UserDefaultKeys.Stock.jinjinStock)
        DataCache.jiejinStocks = stocks
    }
    
    public static func loadJieJinStockStocks() -> [JieJinStock] {
        let stocks:[JieJinStock] = StockUtils.loadData(key: UserDefaultKeys.Stock.jinjinStock)
        DataCache.jiejinStocks = stocks
        return stocks
    }
    
    // 每日涨停
    public static func saveZhangTingStocks(stocks:[ZhangTingStocks]) {
        StockUtils.saveData(data: stocks, key: UserDefaultKeys.Stock.zhangtingStock)
        DataCache.ztStocks = stocks
    }
    
    public static func loadZhangTingStocks() -> [ZhangTingStocks] {
        let stocks:[ZhangTingStocks] = StockUtils.loadData(key: UserDefaultKeys.Stock.zhangtingStock)
        DataCache.ztStocks = stocks
        return stocks
    }
    
    // Mark:Hot
    public static func saveHotBlocks(data:String) {
        let key = UserDefaultKeys.Block.hotBlocks
        Utils.savePersistantData(key: key, data: data)
    }
    public static func loadHotBlocks() -> String? {
        let key = UserDefaultKeys.Block.hotBlocks
        let data = Utils.loadPersistantData(key: key) as? String
        return data;
    }
    public static func saveHotStocks(data:String) {
        let key = UserDefaultKeys.Stock.hotStocks
        Utils.savePersistantData(key: key, data: data)
    }
    public static func loadHotStocks() -> String? {
        let key = UserDefaultKeys.Stock.hotStocks
        let data = Utils.loadPersistantData(key: key) as? String
        return data;
    }
    // Mark:Important
    public static func saveImportantBlocks(data:String) {
        let key = UserDefaultKeys.Block.importantBlocks
        Utils.savePersistantData(key: key, data: data)
    }
    public static func loadImportantBlocks() -> String? {
        let key = UserDefaultKeys.Block.importantBlocks
        let data = Utils.loadPersistantData(key: key) as? String
        return data;
    }
    public static func saveImportantStocks(data:String) {
        let key = UserDefaultKeys.Stock.importantStocks
        Utils.savePersistantData(key: key, data: data)
    }
    public static func loadImportantStocks() -> String? {
        let key = UserDefaultKeys.Stock.importantStocks
        let data = Utils.loadPersistantData(key: key) as? String
        return data;
    }
    
    // Mark: PinYin
    public static func loadStockPinYin() -> [String:String] {
        let key = UserDefaultKeys.Stock.basicStocksPinYin
        let pinyinMap = Utils.loadPersistantData(key: key) as? [String:String]
        if pinyinMap != nil {
            return pinyinMap!
        }
        return [:]
    }
    public static func saveStockPinYin(stockPinYinMap:[String:String]) {
        let key = UserDefaultKeys.Stock.basicStocksPinYin
        Utils.savePersistantData(key: key, data: stockPinYinMap)
    }
    public static func loadBlockPinYin() -> [String:String] {
        let key = UserDefaultKeys.Block.basicBlocksPinYin
        let pinyinMap = Utils.loadPersistantData(key: key) as? [String:String]
        if pinyinMap != nil {
            return pinyinMap!
        }
        return [:]
    }
    public static func saveBlockPinYin(blockPinYinMap:[String:String]) {
        let key = UserDefaultKeys.Block.basicBlocksPinYin
        Utils.savePersistantData(key: key, data: blockPinYinMap)
    }
    
    //-----------------------------------板块周期表----------------------------------
    public static func loadBlockLifeCycleData() -> Data? {
        let key = UserDefaultKeys.Block.blokLifeCycle
        let data = Utils.loadPersistantData(key: key) as? Data
        return data
    }
    public static func saveBlockLifeCycleData(data:Data) {
        let key = UserDefaultKeys.Block.blokLifeCycle
        Utils.savePersistantData(key: (key), data: data)
    }
    
    public static func clearLocalUserDefaults() {
        let dic = UserDefaults.standard.dictionaryRepresentation()
        for key in dic.keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
}
