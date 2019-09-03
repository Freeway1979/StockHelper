//
//  BlockDataService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/3.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class BlockDataService: DataService {
    override init(date: String, keywords: String, title: String) {
        super.init(date: date, keywords: keywords, title: title)
        self.perpage = 1000
        self.handler = { (date, json, dict) in
            
        }
        self.paginationService = self.buildPaginationService()
    }

    private func buildPaginationService() -> DataService {
        let today = Date().formatWencaiDateString()
        let dataService = DataService(date: today,keywords: "cacheToken", title: "BlockList")
        dataService.handler = { [unowned self] (date, json, dict) in
            self.handlePaginationResponse(date: date, json: json, dict: dict)
        }
        return dataService
    }
    
    override func handleResponse(date:String,json:String,dict:Dictionary<String, Any>) {
         
    }
    
    private func handleWenCaiBlocksResponse(date:String,dict:Dictionary<String, Any>) -> [Block] {
        print("\(date) handleWenCaiShandleWenCaiBlocksResponsetocksResponse")
        let rs = dict["result"] as! [[Any]]
        print(rs.count)
        var blocks:[Block] = []
        for item in rs {
            let code = item[0] as! String
            let name = item[1] as! String
            let block = Block(code: String(code.prefix(6)), name: name)
            blocks.append(block)
        }
        return blocks
    }
    
    func handlePaginationResponse(date:String,json:String,dict:Dictionary<String, Any>) {
        let blocks:[Block] = self.handleWenCaiBlocksResponse(date:date, dict: dict)
        if self.onComplete != nil {
            self.onComplete!(blocks)
        }
    }
}
