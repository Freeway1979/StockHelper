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
    
    public static func getBlocksByDate(date:String) -> [WenCaiBlockStat]? {
        if (blockTops == nil) {
            blockTops = [:]
        }
        return blockTops?[date]
    }
    
    public static func setBlocksByDate(date:String, blocks:[WenCaiBlockStat]) {
        if (blockTops == nil) {
            blockTops = [:]
        }
        blockTops?[date] = blocks;
    }
}
