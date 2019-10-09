//
//  XuanguDataService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/10/9.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
class XuanguDataService: StockDataService {
    override func serverItemToModel(item:[Any]) -> Any {
        let code = item[0] as! String
        let name = item[1] as! String
        let stock = Stock(code: String(code.prefix(6)), name: name)
        return stock
    }
}
