//
//  StackTableViewCell.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/4/14.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit

class StackTableViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.commonInit()
    }
    
//    init() {
//        super.init(style:.default, reuseIdentifier: nil)
//    }
//    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        Bundle.main.loadNibNamed("StackTableViewCell", owner: self, options: nil)
        self.commonInit()
    }
    
    
////    override init(frame: CGRect) {
////        super.init(frame: frame)
////        Bundle.main.loadNibNamed("StackTableViewCell", owner: self, options: nil)
////        self.commonInit()
////    }
////    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
      
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
