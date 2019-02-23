//
//  UIUtils.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/2/23.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
import ZKProgressHUD

class UIUtils {
    public static func showLoading() {
        DispatchQueue.main.async(execute: {
            ZKProgressHUD.show()
        })
    }
    public static func dismissLoading() {
        DispatchQueue.main.async(execute: {
            ZKProgressHUD.dismiss()
        })
    }
}
