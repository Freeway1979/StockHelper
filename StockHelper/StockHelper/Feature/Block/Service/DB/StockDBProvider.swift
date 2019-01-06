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
        static let basicStocksUpdateTime = "BasicStocksUpdateTime"
        static let hotStocks = "HotStocks"
        static let importantStocks = "ImportantStocks"
    }
    struct Block {
        static let basicBlocks = "BasicBlocks"
        static let basicBlocksUpdateTime = "BasicStocksUpdateTime"
        static let hotBlocks = "HotBlocks"
        static let importantBlocks = "ImportantStocks"
    }
}

class StockDBProvider {
    // Mark :Basic
    public static func saveBasicBlocksToLocal(data:String) {
        UserDefaults.standard.set(data, forKey: UserDefaultKeys.Block.basicBlocks)
    }
    public static func loadBasicBlocksFromLocal() -> String? {
        let data = UserDefaults.standard.object(forKey: UserDefaultKeys.Block.basicBlocks) as? String
        return data;
    }
    public static func saveBasicStocksToLocal(data:String) {
        UserDefaults.standard.set(data, forKey: UserDefaultKeys.Stock.basicStocks)
    }
    public static func loadBasicStocksFromLocal() -> String? {
        let data = UserDefaults.standard.object(forKey: UserDefaultKeys.Stock.basicStocks) as? String
        return data;
    }
    // Mark:Hot
    public static func saveHotBlocksToLocal(data:String) {
        UserDefaults.standard.set(data, forKey: UserDefaultKeys.Block.hotBlocks)
    }
    public static func loadHotBlocksFromLocal() -> String? {
        let data = UserDefaults.standard.object(forKey: UserDefaultKeys.Block.hotBlocks) as? String
        return data;
    }
    public static func saveHotStocksToLocal(data:String) {
        UserDefaults.standard.set(data, forKey: UserDefaultKeys.Stock.hotStocks)
    }
    public static func loadHotStocksFromLocal() -> String? {
        let data = UserDefaults.standard.object(forKey: UserDefaultKeys.Stock.hotStocks) as? String
        return data;
    }
    // Mark:Important
    public static func saveImportantBlocksToLocal(data:String) {
        UserDefaults.standard.set(data, forKey: UserDefaultKeys.Block.importantBlocks)
    }
    public static func loadImportantBlocksFromLocal() -> String? {
        let data = UserDefaults.standard.object(forKey: UserDefaultKeys.Block.importantBlocks) as? String
        return data;
    }
    public static func saveImportantStocksToLocal(data:String) {
        UserDefaults.standard.set(data, forKey: UserDefaultKeys.Stock.importantStocks)
    }
    public static func loadImportantStocksFromLocal() -> String? {
        let data = UserDefaults.standard.object(forKey: UserDefaultKeys.Stock.importantStocks) as? String
        return data;
    }
}
