//
//  StockUtils.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/12.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
import UIKit

class StockUtils {
    
    public static func getYingLiStock(by code:String) -> YingLiStock? {
        var stocks:[YingLiStock] = DataCache.yingliStocks
        if stocks.count == 0 {
           stocks = StockDBProvider.loadYingLiStocks()
        }
       let stock = stocks.first { (stock) -> Bool in
            return stock.code == code
        }
        return stock
    }
    
    public static func getNiuKuiStock(by code:String) -> NiuKuiStock? {
        var stocks:[NiuKuiStock] = DataCache.niukuiStocks
        if stocks.count == 0 {
            stocks = StockDBProvider.loadNiuKuiStocks()
        }
        let stock = stocks.first { (stock) -> Bool in
            return stock.code == code
        }
        return stock
    }
    
    public static func getZhangTingShuStock(by code:String) -> ZhangTingShuStock? {
        var stocks:[ZhangTingShuStock] = DataCache.ztsStocks
        if stocks.count == 0 {
            stocks = StockDBProvider.loadZhangTingShuStocks()
        }
        let stock = stocks.first { (stock) -> Bool in
            return stock.code == code
        }
        return stock
    }
    
    public static func getJieJinStocks(by code:String) -> [JieJinStock] {
        var stocks:[JieJinStock] = DataCache.jiejinStocks
        if stocks.count == 0 {
            stocks = StockDBProvider.loadJieJinStockStocks()
        }
        var rs = stocks.filter({ (stock) -> Bool in
            return stock.code == code
        })
        rs.sort { (lhs, rhs) -> Bool in
            let r: ComparisonResult = lhs.date.compare(rhs.date)
            if r == .orderedAscending {
                return true
            }
            else if r == .orderedDescending {
                return false
            }
            else {
                return lhs.ratio.compare(rhs.ratio) == .orderedAscending
            }
        }
        return rs
    }
    
    public static func getBlock(by code:String) -> Block {
        return StockServiceProvider.getBlock(by: code)
    }
    
    public static func getBlockByName(_ name:String) -> Block? {
        return StockServiceProvider.getBlockByName(name)
    }
    
    public static func buildHotBlock(by name:String) -> HotBlock? {
        let block = StockUtils.getBlockByName(name)
        if (block != nil) {
            let hotblock = HotBlock(block: block!)
            hotblock.hotLevel = HotLevel.Level1
            return hotblock
        }
        return nil
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
        return stocks
    }
    
    public static func hotStockKey(stock:Stock,block:Block) -> String {
        let key = "\(stock.code)_\(block.code)"
        return key;
    }
    
    // 统计一个股票的概念和另外一个股票(龙头)的概念相同的概念数量
    public static func getSameBlockNames(this:String, that:String) -> [String] {
        let thisStock = getStock(by: this)
        let thatStock = getStock(by: that)
        let thisSet =  NSMutableSet(array: thisStock.gnList)
        let thatSet =  NSMutableSet(array: thatStock.gnList)
        thisSet.intersect(thatSet as! Set<AnyHashable>)
        
//        let rs:[String] = thisSet.map { (item) -> String in
//            return item as! String
//        }
//        return rs
        return thisSet.map { $0 as! String }
    }
    
    // UI
    public static func openStockHQPage(code:String, name:String, from navigator:UINavigationController) {
        WebViewController.open(website: WebSite.getStockPageUrl(code: code), withtitle: name , from: navigator)
    }
    
    public static func openDapanHQPage(code:String, name:String, from navigator:UINavigationController) {
        WebViewController.open(website: WebSite.getDapanPageUrl(code: code), withtitle: name , from: navigator)
    }
    
    public static func gotoStockViewController(code:String, from navigator:UINavigationController) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Stock",bundle: nil)
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "StockViewController")
        (destViewController as! StockViewController).stockCode = code
        navigator.pushViewController(destViewController, animated: true)
    }
    
    //
    
    // Mark :Basic
    public static func saveData<T:Codable>(data:[T], key:String) {
        do {
            let data = try JSONEncoder().encode(data)
            UserDefaults.standard.set(data, forKey: key)
            UserDefaults.standard.synchronize()
            //iCloud
            iCloudUtils.set(anobject: data, forKey: key)
        } catch {
            print(error.localizedDescription)
        }
    }
    public static func loadData<T:Codable>(key:String) -> [T] {
        do {
            var data = UserDefaults.standard.object(forKey: key) as? Data
            if data?.count == 0 {
                //iCloud
                data = iCloudUtils.object(forKey: key) as? Data
            }
            if (data != nil)
            {
                let blocks = try JSONDecoder().decode([T].self, from: data!)
                return blocks
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return [];
    }
    
}
