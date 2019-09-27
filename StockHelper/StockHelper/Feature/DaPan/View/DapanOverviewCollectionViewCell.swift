//
//  DapanOverviewCollectionViewCell.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/9/27.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit

class DapanOverviewCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 1
    }

}
