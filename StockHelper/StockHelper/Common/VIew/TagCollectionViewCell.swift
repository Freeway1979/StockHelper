//
//  TagCollectionViewCell.swift
//  HelloCollectionView
//
//  Created by andy liu on 2019/1/11.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contentButton: TagButton!

    @IBAction func onButtonClicked(_ sender: UIButton) {
        if onClicked != nil {
            onClicked!()
        }
    }
    
    var onClicked:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentButton.layer.cornerRadius = 5;
        self.contentButton.textStyle = .medium
        self.contentButton.textColor = UIColor.white
    }

}
