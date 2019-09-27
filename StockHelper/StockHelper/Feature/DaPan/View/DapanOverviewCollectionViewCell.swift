//
//  DapanOverviewCollectionViewCell.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/27.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift

class DapanOverviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelOverviewText: UILabel!
    @IBOutlet weak var buttonStatus: MIBadgeButton!
    @IBOutlet weak var labelSugguestAction: UILabel!
    @IBOutlet weak var labelSugguestCangWei: UILabel!
    @IBOutlet weak var switchKeepWarning: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 1
    }
    
    func toggleKeepWarning(keepWarning:Bool) {
        switchKeepWarning.isSelected = keepWarning
    }
    
    func applyModel(overviewText:String, status:String, badge:String?, action:String, cangwei:String) {
        labelOverviewText.text = overviewText
        buttonStatus.setTitle(status, for: UIControl.State.normal)
        buttonStatus.badgeString = badge
        labelSugguestAction.text = action
        labelSugguestCangWei.text = cangwei
    }
}
