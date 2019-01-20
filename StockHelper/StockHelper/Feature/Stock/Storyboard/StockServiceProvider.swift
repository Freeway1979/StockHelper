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
    
    private static var hotStockMap:[String:HotStock] = [:]
    private static var hotBlockMap:[String:HotBlock] = [:]
    
    public static func getBlock(by code:String) -> Block {
        return blockMap[code]!
    }
    public static func getStock(by code:String) -> Stock {
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
            if let data = StockDBProvider.loadBasicStocks() {
                let stocks = parseJSONStringToStocks(jsonString: data)
                let pinyinMap = StockDBProvider.loadStockPinYin()
                for item in stocks {
                    item.pinyin = pinyinMap[item.code] ?? ""
                }
                StockServiceProvider.stocks = stocks
                buildStocksMap()
                callback(stocks)
                print("Getting stock data from local")
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
                    StockDBProvider.saveBasicStocks(data: jsonString!)
                    let stocks = parseJSONStringToStocks(jsonString: jsonString!)
                    StockServiceProvider.stocks = stocks
                    buildStocksMap()
                    callback(stocks)
                    translateStocks2PinYin(stocks: stocks)
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
            if let data = StockDBProvider.loadBasicBlocks() {
                let blocks = parseJSONStringToBlocks(jsonString: data)
                let pinyinMap = StockDBProvider.loadBlockPinYin()
                for item in blocks {
                    item.pinyin = pinyinMap[item.code] ?? ""
                }
                StockServiceProvider.blocks = blocks
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
                    StockDBProvider.saveBasicBlocks(data: jsonString!)
                    let blocks = parseJSONStringToBlocks(jsonString: jsonString!)
                    StockServiceProvider.blocks = blocks
                    buildBlocksMap()
                    callback(blocks)
                    translateBlocks2PinYin(blocks: blocks)
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
        let stockCodeList:[String] = block2stocksCodeMap[block.block.code]!
        for code in stockCodeList {
            let stock = stockMap[code]
            if (stock != nil) {
                block.stocks?.append(stock!)
            }
        }
        return block
    }
    
    /// 获取所有热门板块列表
    ///
    /// - Returns: <#return value description#>
    public static func getHotBlocks() -> [HotBlock] {
        var rs:[HotBlock] = []
        for value in self.hotBlockMap.values {
            if value.hotLevel != .NoLevel {
                rs.append(value)
            }
        }
        return rs
    }
    public static func getSyncHotBlocks() -> [HotBlock] {
        let hotblocks = StockDBProvider.loadHotBlocks()
        if(hotblocks?.count ?? 0 > 0) {
            let list:[String] = (hotblocks?.components(separatedBy: ","))!
            for code in list {
                var hotblock = self.hotBlockMap[code]
                if (hotblock == nil) {
                    let block = self.blockMap[code]
                    if (block != nil)
                    {
                        hotblock = HotBlock(block: block!)
                        self.hotBlockMap[code] = hotblock
                    }
                }
                hotblock?.hotLevel = .Level1 // FIXME,HotLevel should be persisted.
            }
        }
        let importantblocks = StockDBProvider.loadImportantBlocks()
        if(importantblocks?.count ?? 0 > 0) {
            let list:[String] = (importantblocks?.components(separatedBy: ","))!
            for code in list {
                var hotblock = self.hotBlockMap[code]
                if (hotblock == nil) {
                    let block = self.blockMap[code]
                    if (block != nil)
                    {
                        hotblock = HotBlock(block: block!)
                        self.hotBlockMap[code] = hotblock
                    }
                }
                hotblock?.importantLevel = .Level1 // FIXME,HotLevel should be persisted.
            }
        }
        var rs:[HotBlock] = []
        for (_ ,value) in self.hotBlockMap {
            rs.append(value)
        }
        return rs
    }
    public static func getStockCodeList(of blockCode:String) -> [String] {
        let rs = block2stocksCodeMap[blockCode]
        if rs == nil {
            return []
        }
        return rs!
    }
    public static func getBlockCodeList(of stockCode:String) -> [String] {
        let rs = stock2blocksCodeMap[stockCode]
        if rs == nil {
            return []
        }
        return rs!
    }
    
    public static func getSyncHotStocks() -> [HotStock] {
        let hotstocks = StockDBProvider.loadHotStocks()
        if(hotstocks?.count ?? 0 > 0) {
            let list:[String] = (hotstocks?.components(separatedBy: ","))!
            for code in list {
                var hotstock = self.hotStockMap[code]
                if (hotstock == nil) {
                    let codes:[String] = code.components(separatedBy: "_")
                    let stockcode = codes[0]
                    let blockcode = codes[1]
                    let block = self.blockMap[blockcode]
                    let stock = self.stockMap[stockcode]
                    if (block != nil && stock != nil)
                    {
                        hotstock = HotStock(stock:stock!,block: block!)
                        hotstock?.hotLevel = .Level1 // FIXME,HotLevel should be persisted.
                        self.hotStockMap[code] = hotstock
                    }
                }
            }
        }
        var rs:[HotStock] = []
        for (_ ,value) in self.hotStockMap {
            rs.append(value)
        }
        return rs
    }
    
    // MARK: Hot Block
    public static func getHotBlock(blockcode:String) -> HotBlock? {
        return hotBlockMap[blockcode]
    }
    
    public static func saveHotBlocks() {
        var rs:[String] = []
        for (_,value) in hotBlockMap {
            if (value.hotLevel != .NoLevel) {
                rs.append(value.block.code)
            }
        }
        let joined = rs.joined(separator: ",")
        StockDBProvider.saveHotBlocks(data: joined)
        
    }
    public static func saveImportantBlocks() {
        var rs:[String] = []
        for (_,value) in hotBlockMap {
            if (value.importantLevel != .NoLevel) {
                rs.append(value.block.code)
            }
        }
        let joined = rs.joined(separator: ",")
        StockDBProvider.saveImportantBlocks(data: joined)
        
    }
    public static func removeHotBlock(block:Block) {
        let hotblock = hotBlockMap[block.code]
        if (hotblock == nil) {
            return
        }
        hotblock?.hotLevel = .NoLevel
        // Save
        self.saveHotBlocks()
    }
    public static func setHotBlock(block:Block,hotLevel:HotLevel) {
        var hotblock = hotBlockMap[block.code]
        if (hotblock == nil)
        {
            hotblock = HotBlock(block: block)
            hotBlockMap[block.code] = hotblock
        }
        hotblock?.hotLevel = hotLevel
        // Save
        self.saveHotBlocks()
    }
    public static func isHotBlock(block:Block) -> Bool {
        let hotblock = hotBlockMap[block.code]
        if (hotblock == nil)
        {
            return false
        }
        return (hotblock?.hotLevel.rawValue)! >= HotLevel.Level1.rawValue
    }
    public static func isImportantBlock(block:Block) -> Bool {
        let hotblock = hotBlockMap[block.code]
        if (hotblock == nil)
        {
            return false
        }
        return (hotblock?.importantLevel.rawValue)! >= HotLevel.Level1.rawValue
    }
    public static func setImportantBlock(block:Block,importantLevel:HotLevel) {
        var hotblock = hotBlockMap[block.code]
        if (hotblock == nil)
        {
            hotblock = HotBlock(block: block)
            hotBlockMap[block.code] = hotblock
        }
        hotblock?.importantLevel = importantLevel
        self.saveImportantBlocks()
    }
    public static func removeImportantBlock(block:Block) {
        let hotblock = hotBlockMap[block.code]
        if (hotblock == nil)
        {
            return
        }
        hotblock?.importantLevel = .NoLevel
        self.saveImportantBlocks()
    }
    // Mark: Hot Stock
    public static func isHotStock(stock:Stock,block:Block) -> Bool {
        let key = StockUtils.hotStockKey(stock: stock, block: block)
        let hotstock = hotStockMap[key]
        if (hotstock == nil)
        {
            return false
        }
        return (hotstock?.hotLevel.rawValue)! >= HotLevel.Level1.rawValue
    }
    public static func getHotStock(stock:Stock,block:Block) -> HotStock? {
        let key = StockUtils.hotStockKey(stock: stock, block: block)
        return hotStockMap[key]
    }
    public static func saveHotStocks() {
        var rs:[String] = []
        for (_,value) in hotStockMap {
            if (value.hotLevel != .NoLevel) {
                let key = StockUtils.hotStockKey(stock: value.stock, block: value.block)
                rs.append(key)
            }
        }
        let joined = rs.joined(separator: ",")
        StockDBProvider.saveHotStocks(data: joined)
        
    }
   
    public static func removeHotStock(stock:Stock,block:Block) {
        let key = StockUtils.hotStockKey(stock: stock, block: block)
        let hotstock = hotStockMap[key]
        if (hotstock == nil) {
            return
        }
        hotstock?.hotLevel = .NoLevel
        // Save
        self.saveHotStocks()
    }
    public static func setHotStock(stock:Stock,block:Block,hotLevel:HotLevel) {
        let key = StockUtils.hotStockKey(stock: stock, block: block)
        var hotStock = hotStockMap[key]
        if (hotStock == nil)
        {
            hotStock = HotStock(stock: stock,block:block)
            hotStockMap[key] = hotStock
        }
        hotStock?.hotLevel = hotLevel
        
        self.saveHotStocks()
    }
    
    // MARK: PINYIN
    private static func translateBlocks2PinYin(blocks:[Block]) {
        let queue = DispatchQueue(label: "com.chaser.stockhelper")
        queue.async {
            var pinyinMap:[String:String] = [:]
            for block in blocks {
                block.pinyin = block.name.transformToPinYinFirstLetter(lowercased: true)
//                print(Thread.isMainThread,block.pinyin)
                pinyinMap[block.code] = block.pinyin
            }
            StockDBProvider.saveBlockPinYin(blockPinYinMap: pinyinMap)
            print("板块拼音转换结束")
        }
    }
    private static func translateStocks2PinYin(stocks:[Stock]) {
        let queue = DispatchQueue(label: "com.chaser.stockhelper")
        queue.async {
            var pinyinMap:[String:String] = [:]
            for stock in stocks {
                stock.pinyin = stock.name.transformToPinYinFirstLetter(lowercased: true)
//                print(Thread.isMainThread,stock.pinyin)
                pinyinMap[stock.code] = stock.pinyin
            }
            StockDBProvider.saveStockPinYin(stockPinYinMap:pinyinMap)
            print("股票拼音转换结束")
        }
    }
    public static func getBasicData() {
        // 板块基本信息列表
        getBlockList { (blocks) in
            print("getBlockList",blocks.count)
            //translateBlocks2PinYin(blocks: blocks)
        }
        // 股票基本信息列表
        getStockList { (stocks) in
            print("getStockList",stocks.count)
            //translateStocks2PinYin(stocks: stocks)
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
