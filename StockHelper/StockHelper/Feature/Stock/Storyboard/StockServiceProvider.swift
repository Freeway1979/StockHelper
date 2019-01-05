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
        var _stockMap:[String:Stock] = [:]
        for stock in stocks {
            _stockMap[stock.code] = stock
        }
        stockMap.removeAll()
        stockMap = _stockMap
    }
    private static func buildBlocksMap() {
        var _blockMap:[String:Block] = [:]
        for block in blocks {
            _blockMap[block.code] = block
        }
        blockMap.removeAll()
        blockMap = _blockMap
    }
    
    private static func parseJSONStringToObjects<T:Decodable>(jsonString:String) -> [T] {
        let jsonData:Data = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let objects = try! decoder.decode([T].self, from: jsonData)
        return objects;
    }
    
    private static func parseJSONStringToStocks(jsonString:String) -> [Stock] {
        return parseJSONStringToObjects(jsonString: jsonString)
    }
    /// 获取所有股票列表（code+name)
    ///
    /// - Parameter callback: <#callback description#>
    public static func getStockList(byForce:Bool = false,
                                    callback:@escaping ([Stock]) -> Void ) {
        if (!byForce) {
            // Get data from memory cache
            if StockServiceProvider.stocks.count > 0 {
                callback(StockServiceProvider.stocks)
                print("Getting stock data from memory cache")
                return
            }
            // Get data from local
            if let data = StockDBProvider.loadBasicStocksFromLocal() {
                let stocks = parseJSONStringToStocks(jsonString: data)
                StockServiceProvider.stocks = stocks
                buildStocksMap()
                callback(stocks)
                print("Getting block data from local")
                return;
            }
        }
        // Get data from remote
        let provider = MoyaProvider<StockService>()
        provider.request(StockService.getStockList) { result in
            // do something with the result (read on for more details)
            if case let .success(response) = result {
                let jsonString = try? response.mapString()
                if jsonString != nil {
                    StockDBProvider.saveBasicStocksToLocal(data: jsonString!)
                    let stocks = parseJSONStringToStocks(jsonString: jsonString!)
                    StockServiceProvider.stocks = stocks
                    buildStocksMap()
                    callback(stocks)
                    print("Getting stock data from remote")
                }
            }
        }
    }
    
    private static func parseJSONStringToBlocks(jsonString:String) -> [Block] {
       return parseJSONStringToObjects(jsonString: jsonString)
    }
    
    /// 获取所有板块列表(code+name+type)
    ///
    /// - Parameter callback: <#callback description#>
    public static func getBlockList(byForce:Bool = false,
                                    callback:@escaping ([Block]) -> Void ) {
        if (!byForce) {
            // Get data from memory cache
            if StockServiceProvider.blocks.count > 0 {
                callback(StockServiceProvider.blocks)
                print("Getting block data from memory cache")
                return
            }
            // Get data from local
            if let data = StockDBProvider.loadBasicBlocksFromLocal() {
                let stocks = parseJSONStringToBlocks(jsonString: data)
                StockServiceProvider.blocks = stocks
                buildBlocksMap()
                callback(blocks)
                print("Getting block data from local")
                return;
            }
        }
        // Get data from remote
        let provider = MoyaProvider<StockService>()
        provider.request(StockService.getBlockList) { result in
            // do something with the result (read on for more details)
            if case let .success(response) = result {
                let jsonString = try? response.mapString()
                if jsonString != nil {
                    StockDBProvider.saveBasicBlocksToLocal(data: jsonString!)
                    let blocks = parseJSONStringToBlocks(jsonString: jsonString!)
                    StockServiceProvider.blocks = blocks
                    buildBlocksMap()
                    callback(blocks)
                    print("Getting block data from remote")
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
                    let hotblocks = ["5G","国防军工","特高压","人工智能"]
                    let hotlist = stocks.filter { (stock) -> Bool in
                        let code = stock.code
                        var rs:[String] = []
                        let listblockcodes = stock2blocksCodeMap[code] ?? []
                        for s in listblockcodes {
                            let block = blockMap[s]
                            for hot in hotblocks {
                                if ( block != nil && (block!.name.contains(hot))) {
                                    rs.append((block!.name))
                                }
                            }
                            
                        }
                        if (rs.count>1) {
                            print(code,stock.name,rs)
                            return true
                        }
                        return false
                    }
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
