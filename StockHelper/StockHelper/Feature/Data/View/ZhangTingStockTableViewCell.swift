//
//  ZhangTingStockTableViewCell.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/22.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift

class ZhangTingStockTableViewCell: UITableViewCell {

    @IBOutlet weak var nameButton: MIBadgeButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var line1Label: UILabel!
    
    @IBOutlet weak var line2Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.commonInit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func commonInit() {
//        nameButton.backgroundColor = UIColor.groupTableViewBackground
//        nameButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
//        nameButton.layer.borderColor = UIColor.groupTableViewBackground.cgColor
//        nameButton.layer.borderWidth = 1
//        nameButton.layer.cornerRadius = 1
//        nameButton.layer.cornerRadius = 5
        
    }
    
    func applyModel(name:String, title:String, line1:String,line2:String, badge:String?) {
        nameButton.setTitle(name, for: UIControl.State.normal)
        nameButton.setTitleColor(UIColor.darkText, for: UIControl.State.normal)
        nameButton.badgeString = badge
        titleLabel.text = title
        line1Label.text = line1
        line2Label.text = line2
    }
}
