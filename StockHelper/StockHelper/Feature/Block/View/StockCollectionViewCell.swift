//
//  StockCollectionViewCell.swift
//  HelloCollectionView
//
//  Created by andyli2 on 2019/1/11.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class StockCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contentButton: UIButton!

    @IBAction func onButtonClicked(_ sender: UIButton) {
        if onClicked != nil {
            onClicked!()
        }
    }
    public enum TextStyle: String {
        case large = "Large"
        case medium = "Medium"
        case small = "Small"
    }
    
    var style: TextStyle = .medium
    var onClicked:(() -> Void)?
    
    var bgColor: UIColor? {
        get {
            return self.contentButton.backgroundColor
        }
        set {
            self.contentButton.backgroundColor = newValue
        }
    }
    var textColor: UIColor? {
        get {
            return self.contentButton.currentTitleColor
        }
        set {
            self.contentButton.setTitleColor(newValue, for: UIControl.State.normal)
        }
    }
    var text: String? {
        get {
            return self.contentButton.currentTitle
        }
        set {
            self.contentButton.setTitle(newValue, for: UIControl.State.normal)
        }
    }
    private func setTextStyle(style:TextStyle) {
        switch style {
        case .large:
            self.contentButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        case .small:
            self.contentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        default:
            self.contentButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentButton.layer.cornerRadius = 5;
        self.style = .medium
    }

}
