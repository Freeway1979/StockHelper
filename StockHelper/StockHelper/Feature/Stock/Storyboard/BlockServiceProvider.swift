//
//  ServiceProvider.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/12/31.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import Foundation
import Moya

class BlockServiceProvider {
    private static var blocks:[StockBlock] = []
    
    public static func getBlockList(callback:@escaping ([StockBlock]) -> Void ) {
        if BlockServiceProvider.blocks.count > 0 {
            callback(BlockServiceProvider.blocks)
            return
        }
        let provider = MoyaProvider<BlockService>()
        provider.request(BlockService.getBlockList) { result in
            // do something with the result (read on for more details)
            if case let .success(response) = result {
                let jsonString = try? response.mapString()
                if jsonString != nil {
                    let jsonData:Data = jsonString!.data(using: .utf8)!
                    //let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                    //print(dict!);
                    let decoder = JSONDecoder()
                    let blocks = try! decoder.decode([StockBlock].self, from: jsonData)
                    BlockServiceProvider.blocks = blocks
                    callback(blocks)
                }
            }
        }
    }
    
    public static func getBlockStocks(code:String,callback:@escaping (StockBlock) -> Void ) {
        let provider = MoyaProvider<BlockService>()
        provider.request(BlockService.getBlockStocks(code: code)) { result in
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
}
