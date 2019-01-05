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
    }
    struct Block {
        static let basicBlocks = "BasicBlocks"
        static let basicBlocksUpdateTime = "BasicStocksUpdateTime"
    }
}

class StockDBProvider {
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
}
