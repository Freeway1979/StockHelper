//
//  Data+GBK.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/2/22.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

extension Data {
    var GBString: String {
        let cfEnc = CFStringEncodings.GB_18030_2000
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
        let str = String(data: self, encoding: String.Encoding(rawValue: enc))
        return str!
    }
}
