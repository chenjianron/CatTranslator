//
//  SSNavigationController.swift
//  SplitScreen
//
//  Created by  HavinZhu on 2020/8/11.
//  Copyright © 2020 HavinZhu. All rights reserved.
//

import Toolkit

class SSNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
