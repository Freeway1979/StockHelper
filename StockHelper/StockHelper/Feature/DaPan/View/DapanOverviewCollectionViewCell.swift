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
    
    @IBOutlet weak var labelZTS: MIBadgeButton!
    @IBOutlet weak var labelDTS: MIBadgeButton!
    @IBOutlet weak var buttonQingXu: UIButton!
    
    var onClicked:(() -> Void)? = nil
    
    var onQingXuClicked:(() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 1
    }
    
    @IBAction func onStatusButtonClicked(_ sender: UIButton) {
        if onClicked != nil {
            onClicked!()
        }
    }
    
    @IBAction func onQingXuButtonClicked(_ sender: UIButton) {
      if onQingXuClicked != nil {
            onQingXuClicked!()
        }
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
    
    func updateZhangDieTingShu(zts:String,dts:String,dtsBadge:String?) {
        self.labelZTS.setTitle(zts, for: UIControl.State.normal)
        self.labelDTS.setTitle(dts, for: UIControl.State.normal)
        self.labelDTS.badgeString = dtsBadge
    }
    
    func updateChaoDuanQingXu(qingxu:String) {
        self.buttonQingXu.setTitle(qingxu, for: UIControl.State.normal)
    }
}
