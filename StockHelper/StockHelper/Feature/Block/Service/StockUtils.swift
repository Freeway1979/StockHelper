//
//  StockUtils.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/12.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class StockUtils {
    public static func getBlock(by code:String) -> Block {
        return StockServiceProvider.getBlock(by: code)
    }
    public static func getStock(by code:String) -> Stock {
        return StockServiceProvider.getStock(by:code)
    }
    /// 获取所有热门板块列表
    ///
    /// - Returns: <#return value description#>
    public static func getHotBlocks() -> [HotBlock] {
        return StockServiceProvider.getHotBlocks()
    }
    /// 某个板块下的所有股票
    ///
    /// - Parameters:
    ///   - code: <#code description#>
    ///   - callback: <#callback description#>
    public static func getBlockStocksDetail(basicBlock:Block) -> Block2Stocks {
        return StockServiceProvider.getSyncBlockStocksDetail(basicBlock:basicBlock)
    }
    
    public static func getStockCodeList(of blockCode:String) -> [String] {
        return StockServiceProvider.getStockCodeList(of: blockCode)
    }
    public static func getBlockCodeList(of stockCode:String) -> [String] {
        return StockServiceProvider.getBlockCodeList(of: stockCode)
    }
    
    
    /// 得到热门板块关联的股票列表
    ///
    /// - Parameter blockList: <#blockList description#>
    /// - Returns: <#return value description#>
    public static func getAssociatedStockList(of hotblocks:[HotBlock],limit:Int = 2) -> [Stock2Blocks] {
        var stocks:[Stock2Blocks] = []
        if hotblocks.count == 0 {
            return stocks
        }
        var stockCodes:Set<String> = []
        let blockCode = hotblocks.first?.block.code
        let stockCodesOfBlock = self.getStockCodeList(of: blockCode!)
        stockCodes = Set(stockCodesOfBlock)
        // 1
        for hotblock in hotblocks {
           let blockCode = hotblock.block.code
           let stockCodesOfBlock = self.getStockCodeList(of: blockCode)
           stockCodes = stockCodes.intersection(stockCodesOfBlock)
        }
        // 2
        for stockCode in stockCodes {
            let stock2blocks = Stock2Blocks(stock: self.getStock(by: stockCode))
            stock2blocks.blocks = hotblocks.map({ (hotblock) -> Block in
                return hotblock.block
            })
            stocks.append(stock2blocks)
        }
//        for stockCode in stockCodes {
//            let blockCodeList = self.getBlockCodeList(of: stockCode)
//            var hotblocksOfCode:[String] = []
//            for hotblock in hotblocks {
//                let bb = hotblock.block.code
//                if blockCodeList.contains(bb) {
//                    hotblocksOfCode.append(bb)
//                }
//            }
//            if hotblocksOfCode.count >= limit {
//                let stock2blocks = Stock2Blocks(stock: self.getStock(by: stockCode))
//                for bb in hotblocksOfCode {
//                    stock2blocks.blocks.append(self.getBlock(by: bb))
//                }
//                stocks.insert(stock2blocks)
//            }
//        }
        // 3
        return stocks
    }
    
    public static func hotStockKey(stock:Stock,block:Block) -> String {
        let key = "\(stock.code)_\(block.code)"
        return key;
    }
}
