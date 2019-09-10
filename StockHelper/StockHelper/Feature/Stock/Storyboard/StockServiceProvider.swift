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
    public static var blocks:[Block] = []
    public static var stocks:[Stock] = []
    private static var stockMap:[String:Stock] = [:]
    private static var blockMap:[String:Block] = [:]
    
    private static var block2stocksCodeMap:[String:[String]] = [:]
    private static var stock2blocksCodeMap:[String:[String]] = [:]
    
    private static var hotStockMap:[String:HotStock] = [:]
    private static var hotBlockMap:[String:HotBlock] = [:]
    
    public static func resetData() {
        blocks.removeAll()
        stocks.removeAll()
        stockMap.removeAll()
        blockMap.removeAll()
        block2stocksCodeMap.removeAll()
        stock2blocksCodeMap.removeAll()
//        hotStockMap = [:]
//        hotBlockMap = [:]
    }
    
    public static func initData() {
       getBasicData()
    }
    
    public static func getBlock(by code:String) -> Block {
        return blockMap[code]!
    }
    
    public static func getBlockByName(_ name:String) -> Block? {
        let block = blocks.first { (bb) -> Bool in
            return bb.name == name
        }
        return block
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

    
    public static func buildBlock2StocksCodeMap() {
        for stock in stocks {
            let stockCode = stock.code
            let gnList:[String] = stock.gnList
            var blocks:[String] = []
            for gn in gnList {
                let block = getBlockByName(gn)
                if block != nil {
                    // build block2stocks
                    let blockCode:String = block!.code
                    var stockCodes:[String]? = block2stocksCodeMap[blockCode];
                    if stockCodes == nil {
                        stockCodes = []
                    }
                    stockCodes?.append(stockCode)
                    block2stocksCodeMap[blockCode] = stockCodes
                    blocks.append(blockCode)
                }
            }
            
            stock2blocksCodeMap[stockCode] = blocks
        }
    }
    
    private static func parseJSONStringToStocks(jsonString:String) -> [Stock] {
        return jsonString.json2Objects()
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
            let stocks:[Stock] = StockDBProvider.loadBasicStocks()
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
    
    public static func parseJSONStringToBlocks(jsonString:String) -> [Block] {
       return Utils.parseJSONGBKStringToObjects(jsonString: jsonString)
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
            let blocks = StockDBProvider.loadBasicBlocks()
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
    
    /// 某个板块下的所有股票
    ///
    /// - Parameters:
    ///   - code: <#code description#>
    ///   - callback: <#callback description#>
    public static func getSyncBlockStocksDetail(basicBlock:Block) -> Block2Stocks {
        let block = Block2Stocks(block: basicBlock)
        let stockCodeList:[String]? = block2stocksCodeMap[block.block.code]
        if stockCodeList != nil {
            for code in stockCodeList! {
                let stock = stockMap[code]
                if (stock != nil) {
                    block.stocks?.append(stock!)
                }
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
    public static func translateBlocks2PinYin(blocks:[Block]) {
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
    public static func translateStocks2PinYin(stocks:[Stock]) {
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
    
    
    public static func getXuanguData(callback: @escaping (_ stocks:[String]) -> Void) {
        // Get data from remote
        let provider = MoyaProvider<StockService>()
        provider.request(StockService.getXuangu) { result in
            // do something with the result (read on for more details)
            if case let .success(response) = result {
                let responseText = try? response.mapString()
                if responseText != nil {
                    let arraySubstrings: [Substring] = responseText!.replacingOccurrences(of: "\n", with: "").split(separator: ",")
                    let arrayStrings: [String] = arraySubstrings.compactMap { "\($0)" }

                    callback(arrayStrings)
                }
            }
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
    }
    
    
}
