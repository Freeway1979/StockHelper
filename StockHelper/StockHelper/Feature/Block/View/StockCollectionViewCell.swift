//
//  StockCollectionViewCell.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/10.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit

class StockCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var codeLabel: UILabel!
    
    @IBOutlet weak var stockNameLabel: UILabel!
//    @IBOutlet weak var blocksStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addGestureRecognizer(UILongPressGestureRecognizer(target: self,
                                                          action: #selector(showMenu(_:))))
    }
    
    @objc func showMenu(_ sender: UILongPressGestureRecognizer) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.setTargetRect(bounds, in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    func dismissMenu() {
        let menu = UIMenuController.shared
        menu.setMenuVisible(false, animated: true)
    }
   
    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        board.string = self.codeLabel.text
        dismissMenu()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?)
        -> Bool {
            print("action",action)
            if action == #selector(UIResponderStandardEditActions.copy(_:)) {
                return true
            }
            return false
    }

}
