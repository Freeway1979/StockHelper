//
//  MAType.swift
//  StockHelper
//
//  Created by Andy Liu on 2018/12/9.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import Foundation

enum MAType:Int {
    case MA3 = 3
    case MA5 = 5
    case MA10 = 10
    case MA20 = 20
}

extension MAType: CaseIterable {}
