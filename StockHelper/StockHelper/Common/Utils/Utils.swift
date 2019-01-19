//
//  Utils.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/12.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    /// 打开同花顺
    public static func openTHS(with code:String = "") {
        UIPasteboard.general.string = code
        let url = URL(string: "AMIHexinPro://cn.com.10jqka.eq")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (rs) in
                print("Succuess \(rs)")
            }
        }
    }
}
