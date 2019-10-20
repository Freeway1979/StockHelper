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
    
    @IBOutlet weak var tagContainerView: UIView!
    
    var xOffset:Int = 0
    
    let spacing:Int = 5
    
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
        
        tagContainerView.isHidden = true
    }
    
    func applyModel(name:String, title:String, line1:String,line2:String, badge:String?) {
        nameButton.setTitle(name, for: UIControl.State.normal)
        nameButton.setTitleColor(UIColor.darkText, for: UIControl.State.normal)
        nameButton.badgeString = badge
        titleLabel.text = title
        line1Label.isHidden = line1.count == 0
        line1Label.text = line1
        line2Label.isHidden = line2.count == 0
        line2Label.text = line2
    }
    
    func resetTags() {
        tagContainerView.isHidden = true
        xOffset = 0
        tagContainerView.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
    }
    
    func addTag(tag:String, dragonBlock:Bool = false) {
        tagContainerView.isHidden = false
        var width = tag.count * 15 + 4
        if width < 30 {
            width = 30
        }
        let tagButton = TagButton(frame: CGRect(x: xOffset, y: 0, width: width, height: 20))
        tagButton.text = tag
        tagButton.style = dragonBlock ? .Primary :.Secondary
        tagButton.setTextStyle(textStyle: .small)
        tagContainerView.addSubview(tagButton)
        xOffset = xOffset + width+spacing
    }
    
    func updateModelWithZhangTing(s:ZhangTingStock?, stock:Stock, dragon:ZhangTingStock?,isHot:Bool = false) {
        let name = stock.name
        let title:String = ""
        var line1:String = ""
        var line2:String = ""
        var badge:String = ""
        line1 = "\(stock.code) 流通值:\(stock.tradeValue.formatMoney)"
        let yingli = stock.yingliStr
        if yingli != nil {
            line1 = "\(line1) \(yingli!)"
        }
        let jiejin = stock.jiejinStr
        if jiejin != nil {
            line1 = "\(line1) \(jiejin!)"
        }
        let hotblocks:[String] = DataCache.getTopBlockNamesForStock(stock: stock)
        if s != nil {
            line2 = "封单额\(s!.ztMoney.formatMoney) 封成比:\(s!.ztRatioBills.formatDot2FloatString) 封流比:\(s!.ztRatioMoney.formatDot2FloatString)"
            badge = s!.ztBanType
        }
        if isHot && badge.count == 0 {
            badge = "Hot"
        }
        self.applyModel(name: name, title: title, line1: line1, line2: line2, badge: badge)
        self.resetTags()
        
        var sameblocks:[String] = []
        if dragon != nil && s != nil {
            if s?.zhangting != dragon?.zhangting {
                sameblocks = StockUtils.getSameBlockNames(this: stock.code, that: dragon!.code)
                sameblocks.forEach { (block) in
                    self.addTag(tag: block, dragonBlock: true)
                }
            } else { //龙头子
                self.addTag(tag: "市场日内龙头", dragonBlock: true)
            }
        }
        var tags:[String] = []
        if sameblocks.count > 0 {
            hotblocks.forEach { (block) in
                if !sameblocks.contains(block) {
                    tags.append(block)
                }
            }
        } else {
            tags = hotblocks
        }
        tags.forEach { (block) in
            self.addTag(tag: block)
        }
    }
}
