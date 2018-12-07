//
//  UITextField+Extension.swift
//  StockHelper
//
//  Created by andyli2 on 2018/12/7.
//  Copyright © 2018 Andy Liu. All rights reserved.
//

import UIKit

// 1
private var maxLengths = [UITextField: Int]()

// 2
extension UITextField {
    
    // 3
    @IBInspectable var maxLength: Int {
        get {
            // 4
            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            // 5
            addTarget(
                self,
                action: #selector(limitLength),
                for: UIControl.Event.editingChanged
            )
        }
    }
    
    @objc func limitLength(textField: UITextField) {
        // 6
        guard let prospectiveText = textField.text, prospectiveText.count > maxLength else {
            return
        }
        
//        let selection = selectedTextRange
//        // 7
//        text = prospectiveText.substringWith(
//            Range<String.Index>(prospectiveText.startIndex ..< prospectiveText.startIndex.advanced(by: maxLength))
//        )
//        selectedTextRange = selection
    }
    
}
