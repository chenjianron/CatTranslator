//
//  ContainerVC.swift
//  CatTranslator
//
//  Created by GC on 2021/9/10.
//

import UIKit
import Toolkit

class PlayCatVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

//MARK: - Interaction
extension PlayCatVC {
    
    @objc func setting(){
        
    }
}

//MARK: - UI
extension PlayCatVC {
    
    func setUpUI(){
        navigationItem.title = __("逗猫")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "SettingIcon"), style: .plain, target: self, action: #selector(setting))
        setUpConstrains()
    }
    
    func setUpConstrains(){
        
    }
}
