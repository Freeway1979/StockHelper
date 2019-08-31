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
    
    func toDictionaryGBK() -> NSDictionary {
        let cfEnc = CFStringEncodings.GB_18030_2000
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
        return self.toDictionary(encoding: String.Encoding(rawValue: enc))
    }

    func toDictionary(encoding:String.Encoding) ->NSDictionary{
        let jsonData:Data = self.data(using: encoding)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    var numberValue: NSNumber? {
        if let value = Int(self) {
            return NSNumber(value: value)
        }
        return nil
    }
    var floatNumberValue: NSNumber? {
        if let value = Float(self) {
            return NSNumber(value: value)
        }
        return nil
    }
}
