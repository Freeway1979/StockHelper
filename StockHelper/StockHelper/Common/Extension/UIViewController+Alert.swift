//
//  UIViewController+Alert.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/10.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title:String?,
                   message:String?,
                   leftHandler: ((UIAlertAction) -> Void)? = nil) {
        self.showAlert(title: title, message: message, leftTitle: "确定", leftHandler: leftHandler, rightTitle: nil, rightHandler: nil)
    }
    
    func showAlert(title:String?,
                   message:String?,
                   leftTitle:String = "确定",
                   leftHandler: ((UIAlertAction) -> Void)? = nil,
                   rightTitle:String? = nil,
                   rightHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let leftAction = UIAlertAction(title: leftTitle, style: .default, handler: leftHandler)
        alertController.addAction(leftAction)
        if rightTitle != nil {
            let rightAction = UIAlertAction(title: rightTitle, style: .cancel, handler: rightHandler)
            alertController.addAction(rightAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}
