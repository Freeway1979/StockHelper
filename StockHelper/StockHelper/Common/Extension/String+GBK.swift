//
//  String+GBK.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/2/23.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation

extension String {
    init?(gbkData:Data) {
        let cfEnc = CFStringEncodings.GB_18030_2000
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
        self.init(data: gbkData, encoding: String.Encoding(rawValue: enc))
    }
}
