//
//  DapanOverviewCollectionViewCell.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/27.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift

private extension UILabel {
    func setTextColor(with moneyText:String) {
        if moneyText.contains("-") {
            self.textColor = UIColor.green
        } else {
            self.textColor = UIColor.red
        }
    }
}

class DapanOverviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelOverviewText: UILabel!
    @IBOutlet weak var buttonStatus: MIBadgeButton!
    @IBOutlet weak var labelSugguestAction: UILabel!
    @IBOutlet weak var labelSugguestCangWei: UILabel!
    @IBOutlet weak var switchKeepWarning: UISwitch!
    
    @IBOutlet weak var labelZTS: MIBadgeButton!
    @IBOutlet weak var labelDTS: MIBadgeButton!
    @IBOutlet weak var buttonQingXu: UIButton!
    
    @IBOutlet weak var labelHGT: UILabel!
    @IBOutlet weak var labelSGT: UILabel!
    @IBOutlet weak var labelNorthMoney: UILabel!
    
    @IBOutlet weak var buttonMarketDragon: MIBadgeButton!
    @IBOutlet weak var buttonDragon: MIBadgeButton!
    
    @IBAction func onMarketDragonClicked(_ sender: MIBadgeButton) {
        
    }
    
    var onClicked:(() -> Void)? = nil
    
    var onQingXuClicked:(() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.layer.borderColor = UIColor.groupTableViewBackground.cgColor
//        self.layer.borderWidth = 1
//        self.layer.cornerRadius = 1
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
    
    
    func updateNorthMoney(hgt:String,sgt:String,northMoney:String) {
        self.labelHGT.text = hgt
        self.labelHGT.setTextColor(with: hgt)
        self.labelSGT.text = sgt
        self.labelSGT.setTextColor(with: sgt)
        self.labelNorthMoney.text = northMoney
        self.labelNorthMoney.setTextColor(with: northMoney)
    }
    
    func updateDragons(marketDragon:ZhangTingStock?,gaoduDragon:ZhangTingStock?) {
        //市场龙头
        var title = marketDragon?.name ?? "-"
        var badge = marketDragon?.ztBanType ?? ""
        self.buttonMarketDragon.setTitle(title, for: UIControl.State.normal)
        self.buttonMarketDragon.badgeString = badge
        //空间龙头
        title = gaoduDragon?.name ?? "-"
        badge = gaoduDragon?.ztBanType ?? ""
        self.buttonMarketDragon.setTitle(title, for: UIControl.State.normal)
        self.buttonMarketDragon.badgeString = badge
    }
}
