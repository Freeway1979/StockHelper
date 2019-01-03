//
//  ServiceProvider.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/12/31.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import Foundation
import Moya

class StockServiceProvider {
    private static var blocks:[StockBlock] = []
    private static var stocks:[Stock] = []
    private static var stockMap:[String:Stock] = [:]
    private static var blockMap:[String:StockBlock] = [:]
    private static var blockCodeMap:[String:[String]] = [:]
    
    public static func getBlockByCode(_ code:String) -> StockBlock {
        return blockMap[code]!
    }
    public static func getStockByCode(_ code:String) -> Stock {
        return stockMap[code]!
    }
    public static func getStockCodeListByBlockCode(_ code:String) -> [String] {
        return blockCodeMap[code]!
    }
    private static func buildStocksMap() {
        for stock in stocks {
            stockMap[stock.code] = stock
        }
    }
    private static func buildBlocksMap() {
        for block in blocks {
            blockMap[block.code] = block
        }
    }
    
    public static func getStockList(callback:@escaping ([Stock]) -> Void ) {
        if StockServiceProvider.stocks.count > 0 {
            callback(StockServiceProvider.stocks)
            return
        }
        let provider = MoyaProvider<StockService>()
        provider.request(StockService.getStockList) { result in
            // do something with the result (read on for more details)
            if case let .success(response) = result {
                let jsonString = try? response.mapString()
                if jsonString != nil {
                    let jsonData:Data = jsonString!.data(using: .utf8)!
                    //let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                    //print(dict!);
                    let decoder = JSONDecoder()
                    let stocks = try! decoder.decode([Stock].self, from: jsonData)
                    StockServiceProvider.stocks = stocks
                    buildStocksMap()
                    callback(stocks)
                }
            }
        }
    }
    public static func getBlockList(callback:@escaping ([StockBlock]) -> Void ) {
        if StockServiceProvider.blocks.count > 0 {
            callback(StockServiceProvider.blocks)
            return
        }
        let provider = MoyaProvider<StockService>()
        provider.request(StockService.getBlockList) { result in
            // do something with the result (read on for more details)
            if case let .success(response) = result {
                let jsonString = try? response.mapString()
                if jsonString != nil {
                    let jsonData:Data = jsonString!.data(using: .utf8)!
                    //let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                    //print(dict!);
                    let decoder = JSONDecoder()
                    let blocks = try! decoder.decode([StockBlock].self, from: jsonData)
                    StockServiceProvider.blocks = blocks
                    buildBlocksMap()
                    callback(blocks)
                }
            }
        }
    }
    
    public static func getSimpleBlockList(callback:@escaping () -> Void ) {
        if StockServiceProvider.blocks.count > 0 {
            callback()
            return
        }
        let provider = MoyaProvider<StockService>()
        provider.request(StockService.getSimpleBlocks) { result in
            // do something with the result (read on for more details)
            if case let .success(response) = result {
                let jsonString = try? response.mapString()
                if jsonString != nil {
                    let blocksList = jsonString?.split(separator: "\n")
                    for _block in blocksList! {
                        let _stocks:[String] = _block.components(separatedBy:",")
                        let length = _stocks.count - 1
                        let blockCode = _stocks[0]
                        let stocks = Array(_stocks[1...length])
                        blockCodeMap[blockCode] = stocks;
                    }
                    callback()
                }
            }
        }
    }
    public static func getBlockStocksDetail(code:String,callback:@escaping (StockBlock) -> Void ) {
        let provider = MoyaProvider<StockService>()
        provider.request(StockService.getBlockStocksDetail(code: code)) { result in
            // do something with the result (read on for more details)
            if case let .success(response) = result {
                let jsonString = try? response.mapString()
                if jsonString != nil {
                    let jsonData:Data = jsonString!.data(using: .utf8)!
                    let decoder = JSONDecoder()
                    let block = try! decoder.decode(StockBlock.self, from: jsonData)
                    callback(block)
                }
            }
        }
    }
    
    public static func getBasicData() {
        getBlockList { (blocks) in
            print("getBlockList",blocks.count)
        }
        getStockList { (stocks) in
            print("getStockList",stocks.count)
        }
        getSimpleBlockList {
            print("getSimpleBlockList")
        }
    }
}
