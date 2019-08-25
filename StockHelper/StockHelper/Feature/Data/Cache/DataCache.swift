//
//  DataCache.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/4/21.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class DataCache {
    public static var blockTops:[String:[WenCaiBlockStat]]? = [:]
    
    public static func reset() {
        blockTops?.removeAll()
    }
    
    public static func getTopBlockNames() -> [String] {
        var blockScoreDic:[String:Int] = [:]
        self.blockTops?.forEach({ (item) in
            let (_, value) = item
            value.forEach({ (block) in
                var vv = blockScoreDic[block.title]
                if (vv == nil) {
                    vv = 0
                }
                vv = vv! + block.score
                blockScoreDic[block.title] = vv
            })
        })
        
        var topList:[String] = []
        for (k,v) in (Array(blockScoreDic).sorted {$0.1 > $1.1}) {
            print("\(k):\(v)")
            topList.append(k)
        }
        return topList
    }
    
    public static func getBlocksByDate(date:String) -> [WenCaiBlockStat]? {
        if (blockTops == nil) {
            blockTops = [:]
        }
        var rs = blockTops?[date]
        if rs == nil {
            rs = []
            blockTops?[date] = rs
        }
        return rs
    }
    
    public static func setBlocksByDate(date:String, blocks:[WenCaiBlockStat]) {
        if (blockTops == nil) {
            blockTops = [:]
        }
        var theBlocks = blocks
        if blocks.count > 20 {
            theBlocks = Array(blocks[0...19])
        }
        blockTops?[date] = theBlocks;
    }
    
    public static func saveToDB() {
        if blockTops?.count == 0 {
            return
        }
        let encoder = JSONEncoder()
        let data = try! encoder.encode(blockTops)
        StockDBProvider.saveBlockLifeCycleData(data: data)
        print("Save block tops to local and iCloud")
    }
    
    public static func loadFromDB() {
       let data = StockDBProvider.loadBlockLifeCycleData()
        if (data != nil) {
            let decoder = JSONDecoder()
            let dict = try! decoder.decode([String:[WenCaiBlockStat]].self, from: data!)
            blockTops?.removeAll()
            blockTops = dict
            print("Load block tops from local and iCloud")
        }
    }
    
    public static func printData() {
        blockTops?.forEach({ (item) in
            let (key, value) = item
            print(key,value);
        })
    }
}
