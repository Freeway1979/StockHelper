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
    }
    struct Block {
        static let basicBlocks = "BasicBlocks"
        static let basicBlocksPinYin = "BasicBlocksPinYin"
        static let basicBlocksUpdateTime = "BasicStocksUpdateTime"
        static let hotBlocks = "HotBlocks"
        static let importantBlocks = "ImportantStocks"
        static let blokLifeCycle = "BlokLifeCycle"
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
    
    // Mark:Hot
    public static func saveHotBlocks(data:String) {
        let key = UserDefaultKeys.Block.hotBlocks
        UserDefaults.standard.set(data, forKey:key)
        UserDefaults.standard.synchronize()
        //iCloud
        iCloudUtils.set(anobject: data, forKey: key)
    }
    public static func loadHotBlocks() -> String? {
        let key = UserDefaultKeys.Block.hotBlocks
        var data = UserDefaults.standard.object(forKey: key) as? String
        if data?.count == 0 {
            //iCloud
            data = iCloudUtils.object(forKey: key) as? String
        }
        return data;
    }
    public static func saveHotStocks(data:String) {
        let key = UserDefaultKeys.Stock.hotStocks
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
        //iCloud
        iCloudUtils.set(anobject: data, forKey: key)
    }
    public static func loadHotStocks() -> String? {
        let key = UserDefaultKeys.Stock.hotStocks
        var data = UserDefaults.standard.object(forKey: key) as? String
        if data?.count == 0 {
            //iCloud
            data = iCloudUtils.object(forKey: key) as? String
        }
        return data;
    }
    // Mark:Important
    public static func saveImportantBlocks(data:String) {
        let key = UserDefaultKeys.Block.importantBlocks
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
        //iCloud
        iCloudUtils.set(anobject: data, forKey: key)
    }
    public static func loadImportantBlocks() -> String? {
        let key = UserDefaultKeys.Block.importantBlocks
        var data = UserDefaults.standard.object(forKey: key) as? String
        if data?.count == 0 {
            //iCloud
            data = iCloudUtils.object(forKey: key) as? String
        }
        return data;
    }
    public static func saveImportantStocks(data:String) {
        let key = UserDefaultKeys.Stock.importantStocks
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
        //iCloud
        iCloudUtils.set(anobject: data, forKey: key)
    }
    public static func loadImportantStocks() -> String? {
        let key = UserDefaultKeys.Stock.importantStocks
        var data = UserDefaults.standard.object(forKey: key) as? String
        if data?.count == 0 {
            //iCloud
            data = iCloudUtils.object(forKey: key) as? String
        }
        return data;
    }
    
    // Mark: PinYin
    public static func loadStockPinYin() -> [String:String] {
        let key = UserDefaultKeys.Stock.basicStocksPinYin
        var pinyinMap = UserDefaults.standard.object(forKey:key)
        if pinyinMap != nil {
            return pinyinMap as! [String : String]
        }
        //iCloud
        pinyinMap = iCloudUtils.object(forKey: key) as? [String:String]
        if pinyinMap != nil {
            return pinyinMap as! [String : String]
        }
        return [:]
    }
    public static func saveStockPinYin(stockPinYinMap:[String:String]) {
        let key = UserDefaultKeys.Stock.basicStocksPinYin
        UserDefaults.standard.set(stockPinYinMap,forKey:key)
        UserDefaults.standard.synchronize()
        //iCloud
        iCloudUtils.set(anobject: stockPinYinMap, forKey: key)
    }
    public static func loadBlockPinYin() -> [String:String] {
        let key = UserDefaultKeys.Block.basicBlocksPinYin
        var pinyinMap = UserDefaults.standard.object(forKey: key)
        if pinyinMap != nil {
            return pinyinMap as! [String : String]
        }
        
        pinyinMap = iCloudUtils.object(forKey: key) as? [String:String]
        if pinyinMap != nil {
            return pinyinMap as! [String : String]
        }
        return [:]
    }
    public static func saveBlockPinYin(blockPinYinMap:[String:String]) {
        let key = UserDefaultKeys.Block.basicBlocksPinYin
        UserDefaults.standard.set(blockPinYinMap,forKey:key)
        UserDefaults.standard.synchronize()
        //iCloud
        iCloudUtils.set(anobject: blockPinYinMap, forKey: key)
    }
    
    //-----------------------------------板块周期表----------------------------------
    public static func loadBlockLifeCycleData() -> Data? {
        let key = UserDefaultKeys.Block.blokLifeCycle
        var data = UserDefaults.standard.object(forKey: key)
        if data != nil {
            return data as? Data
        }
        data = iCloudUtils.object(forKey: key) as? [String:String]
        return data as? Data
    }
    public static func saveBlockLifeCycleData(data:Data) {
        let key = UserDefaultKeys.Block.blokLifeCycle
        UserDefaults.standard.set(data,forKey:key)
        UserDefaults.standard.synchronize()
        //iCloud
        iCloudUtils.set(anobject: data, forKey: key)
    }
    
    public static func clearLocalUserDefaults() {
        let dic = UserDefaults.standard.dictionaryRepresentation()
        for key in dic.keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
}
