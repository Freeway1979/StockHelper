//
//  UIUtils.swift
//  StockHelper
//
//  Created by Andy Liu on 2019/2/23.
//  Copyright © 2019 Andy Liu. All rights reserved.
//

import Foundation
import ZKProgressHUD

class UIUtils {
    public static func showLoading() {
        DispatchQueue.main.async(execute: {
            ZKProgressHUD.show()
        })
    }
    public static func dismissLoading() {
        DispatchQueue.main.async(execute: {
            ZKProgressHUD.dismiss()
        })
    }
    
    public static func gotoViewController(storyboard:String,storyboardId:String, from navigationController:UINavigationController) -> UIViewController {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: storyboard,bundle: nil)
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: storyboardId)
        navigationController.pushViewController(destViewController, animated: true)
        return destViewController
    }
    
    
    
}
