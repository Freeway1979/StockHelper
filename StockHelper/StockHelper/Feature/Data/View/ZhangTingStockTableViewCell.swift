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
    
    @IBOutlet weak var tagStackView: UIStackView!
    
    var xOffset:Int = 0
    
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
        
        tagStackView.isHidden = true
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
        tagStackView.isHidden = true
        xOffset = 0
        tagStackView.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
    }
    
    func addTag(tag:String, dragonBlock:Bool = false) {
        tagStackView.isHidden = false
        let width = tag.count * 15
        let tagButton = TagButton(frame: CGRect(x: xOffset, y: 0, width: tag.count * 12, height: 25))
        tagButton.text = tag
        tagButton.style = dragonBlock ? .Primary :.Secondary
        tagButton.setTextStyle(textStyle: .small)
        tagStackView.addSubview(tagButton)
        xOffset = xOffset + width + Int(tagStackView.spacing)
    }
}
