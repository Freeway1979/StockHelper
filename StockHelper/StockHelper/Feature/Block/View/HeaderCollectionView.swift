//
//  HeaderCollectionView.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/1/12.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import UIKit

class HeaderCollectionView: UICollectionReusableView {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var buttonAction: UIButton!
    
    var onClicked:(() -> Void)? = nil
    var hideAction: Bool {
        get {
            return self.buttonAction.isHidden
        }
        set {
            self.buttonAction.isHidden = newValue
        }
    }
    var actionTitle: String? {
        get {
            self.buttonAction.titleLabel?.text
        }
        set {
            self.buttonAction.setTitle(newValue, for: UIControl.State.normal)
        }
    }
    var onActionButtonClicked:(() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
        self.contentLabel.addGestureRecognizer(tapGesture)
        hideAction = true
    }
    
    @IBAction func onButtonClicked(_ sender: UIButton) {
        if onActionButtonClicked != nil && !hideAction {
            onActionButtonClicked!()
        }
    }
    @objc func tap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.onClicked != nil {
                self.onClicked!()
            }
        }
    }
   
}
