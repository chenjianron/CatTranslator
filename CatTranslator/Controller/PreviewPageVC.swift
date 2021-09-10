//
//  ViewController.swift
//  CatTranslator
//
//  Created by GC on 2021/9/2.
//

import Toolkit
import SnapKit

class PreviewPageVC: UIViewController {
    
    var catHeadName = "Index-CatHead-7" {
        didSet {
            self.catImageView.headView.image = UIImage(named: catHeadName)
        }
    }
    var personHeadName = "Index-FigureHead-2" {
        didSet {
            self.personImageView.headView.image = UIImage(named: personHeadName)
        }
    }
    
    lazy var rightBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: __("跳过"), style: .plain, target: self, action: #selector(rightBarButtonItemClick(_:)))
    }()
    lazy var catImageView:HeadView = {
        let headView = HeadView()
        headView.setType(.cat)
        headView.previewPagemaster = self
        return headView
    }()
    lazy var personImageView:HeadView = {
        let headView = HeadView()
        headView.setType(.person)
        headView.previewPagemaster = self
        return headView
    }()
    lazy var exchangeView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Index-Exchange")
        return imageView
    }()
    lazy var catHeadExchangeBtn:UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "CatButton-Background"), for: .normal)
        button.setTitle(__("点击切换"), for: .normal)
        button.setTitleColor(K.Color.AuxiliaryColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.tag = 1
        button.addTarget(self, action: #selector(selectHead(button:)), for: .touchUpInside)
        return button
    }()
    lazy var personHeadExchangeBtn:UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "PersonButton-Background"), for: .normal)
        button.setTitle(__("点击切换"), for: .normal)
        button.setTitleColor(K.Color.ThemeColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.tag = 2
        button.addTarget(self, action: #selector(selectHead(button:)), for: .touchUpInside)
        return button
    }()
    lazy var titleLabel:UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.text = __("您的猫咪叫什么呢？")
        return titleLabel
    }()
    lazy var inputTextField:UITextField = {
        let textField = UITextField()
        var frame = textField.frame
        frame.size.width = Util.isIPad ? 26 : 16  // 距离左侧的距离
        let leftview = UIView(frame: frame)
        textField.leftView = leftview
        textField.leftViewMode = UITextField.ViewMode.always
        textField.layer.cornerRadius = Util.isIPad ? 29 : 19
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .default
        textField.backgroundColor = UIColor.init(hex: 0xF7F7F7, alpha: 1)
        textField.keyboardType = .default
        textField.textAlignment = .left
        textField.text = __("猫咪")
        textField.delegate = self
        return textField
    }()
    lazy var hintLabel: UILabel = {
        let hintLabel = UILabel()
        hintLabel.font = UIFont.systemFont(ofSize: 13)
        hintLabel.textColor = UIColor.gray
        hintLabel.textAlignment = .left
        hintLabel.text = __("猫咪名")
        hintLabel.isHidden = true
        return hintLabel
    }()
    lazy var saveBtn:UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "SaveBackground"), for: .normal)
        button.setTitle(__("保存"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.setStatusBarHidden(true, with: .none)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.setStatusBarHidden(false, with: .none)
    }
}

// MARK: - Interaction
extension PreviewPageVC {
    
    @objc func rightBarButtonItemClick(_ sender: UIBarButtonItem) {
        UserDefaults.standard.setValue("Index-CatHead-7", forKey: "CatHeadName")
        UserDefaults.standard.setValue("Index-FigureHead-2", forKey: "PersonHeadName")
        UserDefaults.standard.setValue("猫咪", forKey: "CatName")
        self.navigationController?.pushViewController(MainVC(), animated: false)
    }
    
    @objc func selectHead(button:UIButton){
        if button.tag == 1 {
            let headCollectionVC = HeadCollectionVC()
            headCollectionVC.type = .cat
            headCollectionVC.previewPagemaster = self
            self.present(headCollectionVC, animated: false, completion: nil)
        } else {
            let headCollectionVC = HeadCollectionVC()
            headCollectionVC.type = .person
            headCollectionVC.previewPagemaster = self
            self.present(headCollectionVC, animated: false, completion: nil)
        }
    }
    
    @objc func tap(){
        view.endEditing(true)
    }
    
    @objc func save(){
        UserDefaults.standard.setValue(catHeadName, forKey: "CatHeadName")
        UserDefaults.standard.setValue(personHeadName, forKey: "PersonHeadName")
        if inputTextField.text?.count == 0 {
            UserDefaults.standard.setValue("猫咪", forKey: "CatName")
        } else {
            UserDefaults.standard.setValue(inputTextField.text, forKey: "CatName")
        }
        self.navigationController?.pushViewController(MainVC(), animated: false)
    }
 
}

//MARK: - Public
extension PreviewPageVC {
    
    func setCatName(_ name:String){
        catHeadName = name
        dismiss(animated: true, completion: nil)
    }
    func setPersonName(_ name: String){
        personHeadName = name
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - TextView
extension PreviewPageVC:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        hintLabel.isHidden = true
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool{
        print("textFieldShouldClear")
        hintLabel.isHidden = false
        return true
    }
}

// MARK: - UI
extension PreviewPageVC {
    
    func setUpUI(){
        
        let tap1 = UITapGestureRecognizer(target: self, action:#selector(tap))
        tap1.cancelsTouchesInView = false
        view.addGestureRecognizer(tap1)
        navigationController?.navigationBar.tintColor = K.Color.ThemeColor
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        view.addSubview(exchangeView)
        view.addSubview(catImageView)
        view.addSubview(personImageView)
        view.addSubview(catHeadExchangeBtn)
        view.addSubview(personHeadExchangeBtn)
        view.addSubview(titleLabel)
        view.addSubview(inputTextField)
        inputTextField.addSubview(hintLabel)
        view.addSubview(saveBtn)
        
        setUpConstrains()
    }
    
    func setUpConstrains(){
        exchangeView.snp.makeConstraints{ make in
            make.top.equalTo(safeAreaTop).offset(G.share.h(142.0))
            make.centerX.equalToSuperview()
            make.width.equalTo(G.share.w(21.37))
            make.height.equalTo(G.share.h(16.77))
        }
        catImageView.snp.makeConstraints{ make in
            make.width.equalTo(G.share.h(110.68))
            make.height.equalTo(G.share.h(110.68))
            make.right.equalTo(exchangeView.snp.left).offset(-G.share.w(24.9))
            make.top.equalTo(safeAreaTop).offset(G.share.h(100))
        }
        personImageView.snp.makeConstraints{ make in
            make.width.equalTo(G.share.h(110.68))
            make.height.equalTo(G.share.h(110.68))
            make.left.equalTo(exchangeView.snp.right).offset(G.share.w(24.58))
            make.top.equalTo(safeAreaTop).offset(G.share.h(100))
        }
        catHeadExchangeBtn.snp.makeConstraints{ make in
            make.width.equalTo(G.share.w(74.38))
            make.height.equalTo(G.share.h(27))
            make.top.equalTo(catImageView.snp.bottom).offset(G.share.h(28.55))
            make.left.equalTo(catImageView.snp.left).offset(G.share.w(18.31))
            make.right.equalTo(catImageView.snp.right).offset(-G.share.w(18.31))
        }
        personHeadExchangeBtn.snp.makeConstraints{ make in
            make.width.equalTo(G.share.w(74.38))
            make.height.equalTo(G.share.h(27))
            make.top.equalTo(personImageView.snp.bottom).offset(G.share.h(28.55))
            make.left.equalTo(personImageView.snp.left).offset(G.share.w(18.31))
            make.right.equalTo(personImageView.snp.right).offset(-G.share.w(18.31))
        }
        titleLabel.snp.makeConstraints{ make in
            make.width.equalTo(G.share.w(126))
            make.height.equalTo(G.share.h(20))
            make.top.equalTo(catHeadExchangeBtn.snp.bottom).offset(G.share.h(28.95))
            make.left.equalTo(catHeadExchangeBtn.snp.left).offset(G.share.w(6.17))
        }
        inputTextField.snp.makeConstraints{ make in
            make.width.equalTo(G.share.w(264))
            make.height.equalTo(G.share.h(38))
            make.top.equalTo(titleLabel.snp.bottom).offset(G.share.h(11))
            make.centerX.equalToSuperview()
        }
        hintLabel.snp.makeConstraints{ make in
            make.width.equalTo(G.share.w(50))
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Util.isIPad ? 29 : 19)
        }
        saveBtn.snp.makeConstraints{ make in
            make.width.equalTo(Util.isIPad ? 200 : G.share.w(146))
            make.height.equalTo(Util.isIPad ? 72.6 : G.share.h(53))
            make.top.equalTo(inputTextField.snp.bottom).offset(G.share.h(130))
            make.centerX.equalToSuperview()
        }
    }
}
