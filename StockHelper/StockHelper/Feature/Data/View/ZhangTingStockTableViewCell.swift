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
        line1Label.text = line1
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
        let tagButton = TagButton(frame: CGRect(x: xOffset, y: 0, width: width, height: 25))
        tagButton.text = tag
        tagButton.style = dragonBlock ? .Primary :.Secondary
        tagButton.setTextStyle(textStyle: .small)
        tagContainerView.addSubview(tagButton)
        xOffset = xOffset + width+spacing
    }
}
