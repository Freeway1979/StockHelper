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
    }
    
    override func buildPaginationService() -> DataService {
        let dataService = DataService(date: self.date,keywords: "cacheToken", title: "BlockList")
        return dataService
    }
    
    override func serverItemToModel(item: [Any]) -> Any? {
        let code = item[0] as! String
        let name = item[1] as! String
        let block = Block(code: String(code.prefix(6)), name: name)
        return block
    }
}
