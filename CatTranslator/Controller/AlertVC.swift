//
//  AlertVC.swift
//  CatTranslator
//
//  Created by GC on 2021/9/16.
//

import UIKit
import Toolkit

class AlertVC: UIViewController {
    
    lazy var contentView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    lazy var textLabel:UILabel = {
        let lable = UILabel()
        lable.text = __("您的猫咪叫什么呢？")
        lable.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lable.textAlignment = .left
        return lable
    }()
    lazy var textField:UITextField = {
        
        let textField = UITextField()
        var frame = textField.frame
        frame.size.width = 10 // 距离左侧的距离
        let leftview = UIView(frame: frame)
        textField.leftView = leftview
        textField.leftViewMode = UITextField.ViewMode.always
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.keyboardType = .default
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hex: 0xF7F7F7)
        textField.placeholder = __("猫咪名")
        textField.text = UserDefaults.standard.value(forKey: "CatName") as? String
        return textField
        
    }()
    lazy var cancelBtn: UIButton = {
       let button = UIButton()
        button.setTitle(__("取消"), for: .normal)
        button.setTitleColor(UIColor(hex: 0x007AFF), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    lazy var okBtn:UIButton = {
        let button = UIButton()
        button.setTitle(__("确认"), for: .normal)
        button.setTitleColor(UIColor(hex: 0x007AFF), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        return button
    }()
    lazy var HView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0x3C3C43,alpha: 0.36)
        return view
    }()
    lazy var VView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0x3C3C43,alpha: 0.36)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AlertVC {
    
    @objc func cancel() {
        dismiss(animated: false, completion: nil)
    }
    @objc func confirm(){
        if textField.text!.count > 0 {
            UserDefaults.standard.setValue(textField.text!, forKey: "CatName")
        } else {
            UserDefaults.standard.setValue(__("猫咪"), forKey: "CatName")
        }
        dismiss(animated: true, completion: nil)
    }
    @objc func tap(){
        view.endEditing(true)
    }
}

extension AlertVC {
    
    func setupUI(){
        
        let tap1 = UITapGestureRecognizer(target: self, action:#selector(tap))
        tap1.cancelsTouchesInView = false
        view.addGestureRecognizer(tap1)
        view.backgroundColor = UIColor(hex: 0x000000).withAlphaComponent(0.5)
        view.addSubview(contentView)
        contentView.addSubview(textField)
        contentView.addSubview(textLabel)
        contentView.addSubview(HView)
        contentView.addSubview(cancelBtn)
        contentView.addSubview(VView)
        contentView.addSubview(okBtn)
        setupConstraint()
    }
    
    func setupConstraint(){
        
        contentView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.width.equalTo(270)
            make.height.equalTo(172)
            make.top.equalTo(safeAreaTop).offset(G.share.h(170))
        }
        textLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(31.3)
            make.left.equalTo(31.31)
            make.width.equalTo(220)
        }
        textField.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(textLabel.snp.bottom).offset(11)
            make.width.equalTo(230)
            make.height.equalTo(38)
        }
        HView.snp.makeConstraints{ make in
            make.bottom.equalToSuperview().inset(44)
            make.width.equalToSuperview()
            make.height.equalTo(0.5)
        }
        VView.snp.makeConstraints{ make in
            make.top.equalTo(HView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
        cancelBtn.snp.makeConstraints{ make in
            make.left.bottom.equalToSuperview()
            make.top.equalTo(HView.snp.bottom)
            make.right.equalTo(VView.snp.left)
        }
        okBtn.snp.makeConstraints{ make in
            make.right.bottom.equalToSuperview()
            make.top.equalTo(HView.snp.bottom)
            make.left.equalTo(VView.snp.right)
        }
    }
}
