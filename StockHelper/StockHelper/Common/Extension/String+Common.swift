//
//  String+Common.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/2/22.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
extension String {
    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            
            return String(subString)
        } else {
            return self
        }
    }
}
