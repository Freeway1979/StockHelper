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
    public static func saveBasicBlocks(data:String) {
        let key = UserDefaultKeys.Block.basicBlocks
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
        //iCloud
        iCloudUtils.set(anobject: data, forKey: key)
    }
    public static func loadBasicBlocks() -> String? {
        let key = UserDefaultKeys.Block.basicBlocks
        var data = UserDefaults.standard.object(forKey: key) as? String
        if data?.count == 0 {
            //iCloud
            data = iCloudUtils.object(forKey: key) as? String
        }
        return data;
    }
    public static func saveBasicStocks(data:String) {
        let key = UserDefaultKeys.Stock.basicStocks
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
        //iCloud
        iCloudUtils.set(anobject: data, forKey: key)
    }
    public static func loadBasicStocks() -> String? {
        let key = UserDefaultKeys.Stock.basicStocks
        var data = UserDefaults.standard.object(forKey: key) as? String
        if data?.count == 0 {
            //iCloud
            data = iCloudUtils.object(forKey: key) as? String
        }
        return data;
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
