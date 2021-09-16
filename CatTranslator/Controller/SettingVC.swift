//
//  SettingVC.swift
//  CatTranslator
//
//  Created by GC on 2021/9/16.
//

import UIKit
import Toolkit

class SettingVC: UIViewController {
    
    let titles = [[__("修改昵称")],[__("帮助"),__("意见反馈")],[__("分享给好友"), __("给个评价"),__("隐私政策"), __("用户协议")]]

    lazy var leftBarBtn:UIBarButtonItem = {
        let leftBarBtn = UIBarButtonItem(image: UIImage(named: "back.png")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backToPrevious))
        return leftBarBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// MARK: - UI
extension SettingVC {
    
}

// MARK: - public
extension SettingVC {
    
    @objc func backToPrevious(){
//        Statistics.event(.SettingsTap, label: "返回")
        self.navigationController!.popViewController(animated: false)
    }
}
