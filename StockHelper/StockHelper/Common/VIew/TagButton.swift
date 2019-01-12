//
//  TagButton.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/12.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit

@IBDesignable
class TagButton: UIButton {
    
    // weak data reference
    weak var userInfo:AnyObject?
    
    public enum TextStyle: String {
        case large = "Large"
        case medium = "Medium"
        case small = "Small"
    }
    public enum Style: String {
        case Primary = "Primary"
        case Secondary = "Secondary"
        case Default = "Default"
    }
    var style:Style = .Default {
        didSet {
            if style == .Primary {
                self.bgColor = UIColor.red
                self.textColor = UIColor.white
            }
            else if style == .Secondary {
                self.bgColor = UIColor.orange
                self.textColor = UIColor.white
            } else {
                self.bgColor = UIColor.white
                self.textColor = UIColor.black
            }
            
        }
    }
    var textStyle: TextStyle = .medium
  
    @IBInspectable var bgColor: UIColor? {
        get {
            return self.backgroundColor
        }
        set {
            self.backgroundColor = newValue
        }
    }
    @IBInspectable var textColor: UIColor? {
        get {
            return self.currentTitleColor
        }
        set {
            self.setTitleColor(newValue, for: UIControl.State.normal)
        }
    }
    @IBInspectable var text: String? {
        get {
            return self.currentTitle
        }
        set {
            self.setTitle(newValue, for: UIControl.State.normal)
        }
    }
    private func setTextStyle(textStyle:TextStyle) {
        switch textStyle {
        case .large:
            self.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        case .small:
            self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        default:
            self.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("TagButton", owner: self, options: nil)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.layer.cornerRadius = 5;
        self.style = .Default
    }

}
