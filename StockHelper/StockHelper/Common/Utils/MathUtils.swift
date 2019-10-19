//
//  MathUtils.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/10/17.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

class MathUtils {
    
    public static func combination<T>(data: [T], handleEachResult:(([T]) -> Void)? = nil) {
        for i in 1 ..< 1 << data.count {
            doEachResult(data: data, index: i, handleEachResult: handleEachResult)
        }
    }

    private static func doEachResult<T>(data: [T], index: Int,handleEachResult:(([T]) -> Void)? = nil) {
        var result = [T]()
        for i in 0 ..< data.count {
            if (index >> i) & 1 == 1 {
                result.append(data[i])
            }
        }
        print(result.count)
        if handleEachResult != nil {
            handleEachResult!(result)
        }
    }

}

