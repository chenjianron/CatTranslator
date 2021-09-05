//
//  ViewController.swift
//  CatTranslator
//
//  Created by GC on 2021/9/2.
//

import Toolkit

class PreviewPageVC: UIViewController {
    
    lazy var rightBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: __("跳过"), style: .plain, target: self, action: #selector(rightBarButtonItemClick(_:)))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.setStatusBarHidden(true, with: .none)
        
    }

}


// MARK: - Interaction
extension PreviewPageVC {
    @objc func rightBarButtonItemClick(_ sender: UIBarButtonItem) {
        
    }
}

// MARK: - UI
extension PreviewPageVC {
    
    func setUpUI(){
        navigationController?.navigationBar.tintColor = K.Color.ThemeColor
        navigationItem.rightBarButtonItem = rightBarButtonItem
        setUpConstrains()
    }
    
    func setUpConstrains(){
        
    }
}
