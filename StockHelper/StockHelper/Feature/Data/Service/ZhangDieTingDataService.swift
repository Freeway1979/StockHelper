//
//  ZhangDieTingDataService.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/28.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
class ZhangDieTingDataService: StockDataService {
    override func serverItemToModel(item:[Any]) -> Any {
        let zdt = item[4] as! String
        return zdt
    }
}
