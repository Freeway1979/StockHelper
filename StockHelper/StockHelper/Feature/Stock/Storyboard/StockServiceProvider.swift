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
    private static var blocks:[Block] = []
    private static var stocks:[Stock] = []
    private static var stockMap:[String:Stock] = [:]
    private static var blockMap:[String:Block] = [:]
    
    private static var block2stocksCodeMap:[String:[String]] = [:]
    private static var stock2blocksCodeMap:[String:[String]] = [:]
    
    public static func getBlockByCode(_ code:String) -> Block {
        return blockMap[code]!
    }
    public static func getStockByCode(_ code:String) -> Stock {
        return stockMap[code]!
    }
    public static func getStockCodeListByBlockCode(_ code:String) -> [String] {
        return block2stocksCodeMap[code]!
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
    
    /// 获取所有股票列表（code+name)
    ///
    /// - Parameter callback: <#callback description#>
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
    
    /// 获取所有板块列表(code+name+type)
    ///
    /// - Parameter callback: <#callback description#>
    public static func getBlockList(callback:@escaping ([Block]) -> Void ) {
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
                    let blocks = try! decoder.decode([Block].self, from: jsonData)
                    StockServiceProvider.blocks = blocks
                    buildBlocksMap()
                    callback(blocks)
                }
            }
        }
    }
    
    
    /// 获取板块和股票映射列表（代码）
    ///
    /// - Parameter callback: <#callback description#>
    public static func getSimpleBlock2StockList(callback:@escaping () -> Void ) {
        let provider = MoyaProvider<StockService>()
        provider.request(StockService.getSimpleBlock2Stocks) { result in
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
                        block2stocksCodeMap[blockCode] = stocks;
                    }
                    callback()
                }
            }
        }
    }
    
    /// 获取股票和板块映射列表（代码）
    ///
    /// - Parameter callback: <#callback description#>
    public static func getSimpleStock2BlockList(callback:@escaping () -> Void ) {
        if StockServiceProvider.blocks.count > 0 {
            callback()
            return
        }
        let provider = MoyaProvider<StockService>()
        provider.request(StockService.getSimpleStock2Blocks) { result in
            // do something with the result (read on for more details)
            if case let .success(response) = result {
                let jsonString = try? response.mapString()
                if jsonString != nil {
                    let stockList = jsonString?.split(separator: "\n")
                    for _stock in stockList! {
                        let _blocks:[String] = _stock.components(separatedBy:",")
                        let length = _blocks.count - 1
                        let stockCode = _blocks[0]
                        let blocks = Array(_blocks[1...length])
                        stock2blocksCodeMap[stockCode] = blocks;
                    }
                    callback()
                }
            }
        }
    }
    
    /// 某个板块下的所有股票
    ///
    /// - Parameters:
    ///   - code: <#code description#>
    ///   - callback: <#callback description#>
    public static func getSyncBlockStocksDetail(basicBlock:Block) -> Block2Stocks {
        let block = Block2Stocks(block: basicBlock)
        let stockCodeList:[String] = block2stocksCodeMap[block.code]!
        for code in stockCodeList {
            let stock = stockMap[code]
            if (stock != nil) {
                block.stocks?.append(stock!)
            }
        }
        return block
    }
    
    public static func getSyncHotBlocks() -> [Block] {
        let list = Array(blocks[0...4])
        return list
    }
    public static func getSyncHotStocks() -> [Stock] {
        let list = Array(stocks[0...4])
        return list
    }
    public static func getSyncImportantBlocks() -> [Block] {
        let list = Array(blocks[4...10])
        return list
    }
    
    public static func getBasicData() {
        // 板块基本信息列表
        getBlockList { (blocks) in
            print("getBlockList",blocks.count)
        }
        // 股票基本信息列表
        getStockList { (stocks) in
            print("getStockList",stocks.count)
        }
        // 板块和股票映射关系(code)
        getSimpleBlock2StockList {
            print("getSimpleBlock2StockList")
        }
        // 股票和板块映射关系(code)
        getSimpleStock2BlockList {
            print("getSimpleStock2BlockList")
        }
    }
    
    
}
