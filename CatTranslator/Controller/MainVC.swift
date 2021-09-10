//
//  MainVC.swift
//  CatTranslator
//
//  Created by GC on 2021/9/2.
//

import UIKit
import Toolkit
import AVFoundation

enum headType {
    case cat
    case person
}

class MainVC: UIViewController {
    
    var currentType:headType?
    
    let audio = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19"]
    
    var catHeadName = UserDefaults.standard.value(forKey: "CatHeadName"){
        didSet {
            self.catImageView.headView.image = UIImage(named: catHeadName as! String)
            UserDefaults.standard.setValue(catHeadName, forKey: "CatHeadName")
        }
    }
    var personHeadName = UserDefaults.standard.value(forKey: "PersonHeadName") {
        didSet {
            self.personImageView.headView.image = UIImage(named: personHeadName as! String)
            UserDefaults.standard.setValue(personHeadName, forKey: "PersonHeadName")
        }
    }
    var catName = UserDefaults.standard.value(forKey: "CatName")
    var first:Bool = true
    
    lazy var record:RTMAudioRecord? = {
        let record = RTMAudioRecord()
       return record
    }()
    lazy var catBackgroundBoard: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "CatHeadBackground")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var personBackgroundBoard: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "PersonHeadBackground")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var catLanguageBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "CatLanguageBackground")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var personLanguageBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "PersonLanguageBackground")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var catImageView:HeadView = {
        let headView = HeadView()
        headView.setType(.cat)
        headView.indexPageMaster = self
        headView.headView.image = UIImage(named: catHeadName as! String)
        return headView
    }()
    lazy var personImageView:HeadView = {
        let headView = HeadView()
        headView.setType(.person)
        headView.indexPageMaster = self
        headView.headView.image = UIImage(named: personHeadName as! String)
        return headView
    }()
    lazy var catRecordBtn:UIButton = {
        let button = UIButton()
        button.tag = 1
        button.setImage(#imageLiteral(resourceName: "CatRecordBtn"), for: .normal)
        button.addTarget(self, action: #selector(recordAuthority(button:)), for: .touchDown)
        button.addTarget(self, action: #selector(catRecord), for: .touchUpInside)
        button.addTarget(self, action: #selector(catRecord), for: .touchUpOutside)
        return button
    }()
    lazy var personRecordBtn:UIButton = {
        let button = UIButton()
        button.tag = 2
        button.setImage(#imageLiteral(resourceName: "PersonRecordBtn"), for: .normal)
        button.addTarget(self, action: #selector(recordAuthority(button:)), for: .touchDown)
        button.addTarget(self, action: #selector(personRecord), for: .touchUpInside)
        button.addTarget(self, action: #selector(personRecord), for: .touchUpOutside)
        return button
    }()
    lazy var catlabel: UILabel = {
        let label = UILabel()
        label.text = __("长按")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    lazy var personlabel: UILabel = {
        let label = UILabel()
        label.text = __("长按")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    lazy var catLanguagelabel: UILabel = {
        let label = UILabel()
        label.text = __("请长按录制猫语…")
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 6
        return label
    }()
    lazy var personLanguagelabel: UILabel = {
        let label = UILabel()
        label.text = __("请长按录制人声...")
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 6
        return label
    }()
    lazy var audioBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "RecordBackground"), for: .normal)
        button.addTarget(self, action: #selector(firstPlay), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}


// MARK: - Public
extension MainVC {
    func setCatName(_ name:String){
        catHeadName = name
        dismiss(animated: true, completion: nil)
    }
    func setPersonName(_ name: String){
        personHeadName = name
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private
extension MainVC {
    
    //判断猫录音后的录音时长和音量
    func judgeCatRecord(){
        
        if record!.recorder!.currentTime <= 3 {
            catLanguagelabel.text = __("录制时间太短，请录制3s以上哦..")
            record!.upAction()
            return
        }
        if (record!.recorder!.peakPower(forChannel: 0)) < -35 {
            catLanguagelabel.text = __("没有听清猫猫的声音哦..")
            record!.upAction()
            return
        }
        catLanguagelabel.text = catName as! String + ": " + Quotations[Int.random(in: 0...49)]
        record!.upAction()
        
    }
    
    //判断人录音后的录音时长和音量
    func judgePersonRecord(){
        
        if record!.recorder!.currentTime <= 3 {
            personLanguagelabel.text = __("录制时间太短，请录制3s以上哦..")
            record!.upAction()
            return
        }
        if (record!.recorder!.peakPower(forChannel: 0)) < -35 {
            personLanguagelabel.text = __("声音太小啦，没有听清…")
            record!.upAction()
            return
        }
        personLanguageBackground.isHidden = true
        audioBtn.isHidden = false
        first = true
        record!.upAction()
    }
    
    //判断是哪一个录音按钮点击了
    func judgeBtn(button:UIButton){
        if button.tag == 1 {
            self.catRecordTouchDown()
        }else {
            self.personRecordTouchDown()
        }
    }
    
    //跳转到设置页
    func gotoSetUp(){
        let url = URL(string: UIApplication.openSettingsURLString)
        UIApplication.shared.open(url!, options: [:]) { (result) in
        }
    }
    
    //麦克风二次权限
    func MirAuthorization(){
        let alert = UIAlertController(title: __("无麦克风权限"), message: __("无麦克风权限，请在系统设置中允许授予%@的使用权限"), preferredStyle: .alert)
        let setting = UIAlertAction(title: __("去设置"), style: .default) { (action) in
            self.gotoSetUp()
        }
        let cancel = UIAlertAction(title: __("取消"), style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(setting)
        self.present(alert, animated: true, completion: nil)
    }
    
    func catRecordBtnStatus(status:Bool){
        
        if !status {
            catRecordBtn.setImage(#imageLiteral(resourceName: "CatRecordBtn-Gif"), for: .normal)
        }else {
            catRecordBtn.setImage(#imageLiteral(resourceName: "CatRecordBtn"), for: .normal)
        }
        catLanguagelabel.text = __("正在聆听猫猫说话…")
        catImageView.headView.isUserInteractionEnabled = status
        personRecordBtn.isUserInteractionEnabled = status
        personImageView.isUserInteractionEnabled = status
    }
    
    func personRecordBtnStatus(status:Bool){
        if !status {
            personRecordBtn.setImage(#imageLiteral(resourceName: "PersonRecordBtn-Gif"), for: .normal)
        }else {
            personRecordBtn.setImage(#imageLiteral(resourceName: "PersonRecordBtn"), for: .normal)
        }
        personLanguagelabel.text = __("正在为您翻译…")
        personImageView.headView.isUserInteractionEnabled = status
        catImageView.headView.isUserInteractionEnabled = status
        catRecordBtn.isUserInteractionEnabled = status
    }
    
    //麦克风权限
    @objc func recordAuthority(button:UIButton){
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { (result) in
                if result {
                    DispatchQueue.main.async {
                        self.judgeBtn(button: button)
                    }
                }
            }
            break
        case .authorized:
            DispatchQueue.main.async {
                self.judgeBtn(button: button)
            }
            break
        default:
            MirAuthorization()
            break
        }
    }
}

// MARK: - Interaction
extension MainVC {

    @objc func catRecordTouchDown(){
        catRecordBtnStatus(status: false)
        record!.downAction()
    }
    @objc func catRecord(){
        catRecordBtnStatus(status: true)
        judgeCatRecord()
    }
    @objc func personRecordTouchDown(){
        personRecordBtnStatus(status: false)
        record!.downAction()
    }
    @objc func personRecord(){
        personRecordBtnStatus(status: true)
        judgePersonRecord()
    }
    // 首次播放人语转猫语的录音
    @objc func firstPlay(){
        
        guard let url = Bundle.main.url(forResource: audio[Int.random(in: 0...18)], withExtension: ".wav") else {
            return
        }
        if first {
            audioBtn.isEnabled = false
            catRecordBtn.isEnabled = false
            record?.playAction(url,self)
        } else {
            if record?.player?.isPlaying == true {
                record?.player?.stop()
            } else {
                catRecordBtn.isEnabled = false
                record?.playAction(url,self)
            }
        }
        
    }
}

//MARK: - AVAudioPlayerDelegate
extension MainVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully: Bool){
        if first {
            audioBtn.isEnabled = true
            catRecordBtn.isEnabled = true
            first = false
        } else {
            catRecordBtn.isEnabled = true
        }
        
    }
}

//MARK: - UI
extension MainVC {
    
    func setUpUI(){
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.title = __("翻译器")
        view.addSubview(catBackgroundBoard)
        view.addSubview(personBackgroundBoard)
        catBackgroundBoard.addSubview(catImageView)
        catBackgroundBoard.addSubview(catLanguageBackground)
        catBackgroundBoard.addSubview(catRecordBtn)
        catBackgroundBoard.addSubview(catlabel)
        catLanguageBackground.addSubview(catLanguagelabel)
        
        personBackgroundBoard.addSubview(personLanguageBackground)
        personBackgroundBoard.addSubview(personImageView)
        personBackgroundBoard.addSubview(personRecordBtn)
        personBackgroundBoard.addSubview(personlabel)
        personBackgroundBoard.addSubview(personLanguagelabel)
        personBackgroundBoard.addSubview(audioBtn)
        personLanguageBackground.addSubview(personLanguagelabel)
        setUpConstrains()
    }
    
    func setUpConstrains(){
        catBackgroundBoard.snp.makeConstraints{ make in
            make.width.equalTo(G.share.w(332))
            make.height.equalTo(G.share.h(231))
            make.top.equalTo(safeAreaTop).offset(G.share.h(30))
            make.centerX.equalToSuperview()
        }
        personBackgroundBoard.snp.makeConstraints{ make in
            make.width.equalTo(G.share.w(332))
            make.height.equalTo(G.share.h(231))
            make.top.equalTo(catBackgroundBoard.snp.bottom).offset(G.share.w(11))
            make.centerX.equalToSuperview()
        }
        
        catImageView.snp.makeConstraints{ make in
            make.width.equalTo(G.share.h(103))
            make.height.equalTo(G.share.h(103))
            make.top.equalToSuperview().offset(G.share.h(28.5))
            make.left.equalToSuperview().offset(G.share.w(28.5))
        }
        personImageView.snp.makeConstraints{ make in
            make.width.equalTo(G.share.h(103))
            make.height.equalTo(G.share.h(103))
            make.top.equalToSuperview().offset(G.share.h(20.5))
            make.right.equalToSuperview().offset(-G.share.w(20))
        }
        catLanguageBackground.snp.makeConstraints{ make in
            make.width.equalTo(G.share.w(161))
            make.height.equalTo(G.share.h(103))
            make.top.equalToSuperview().offset(G.share.h(24.5))
            make.right.equalToSuperview().offset(-G.share.w(20))
        }
        personLanguageBackground.snp.makeConstraints{ make in
            make.width.equalTo(G.share.w(161))
            make.height.equalTo(G.share.h(103))
            make.top.equalToSuperview().offset(G.share.h(24.5))
            make.left.equalToSuperview().offset(G.share.w(28.3))
        }
        catRecordBtn.snp.makeConstraints{ make in
            make.width.equalTo(G.share.w(63))
            make.height.equalTo(G.share.h(41))
            make.bottom.equalTo(-G.share.h(35.5))
            make.centerX.equalToSuperview()
        }
        personRecordBtn.snp.makeConstraints{ make in
            make.width.equalTo(G.share.w(63))
            make.height.equalTo(G.share.h(41))
            make.bottom.equalTo(-G.share.h(35.5))
            make.centerX.equalToSuperview()
        }
        catlabel.snp.makeConstraints { make in
//            make.width.equalTo(G.share.w(24))
//            make.height.equalTo(G.share.h(17))
            make.bottom.equalTo(-G.share.h(12))
            make.centerX.equalToSuperview()
        }
        personlabel.snp.makeConstraints { make in
//            make.width.equalTo(G.share.w(24))
//            make.height.equalTo(G.share.h(17))
            make.bottom.equalTo(-G.share.h(12))
            make.centerX.equalToSuperview()
        }
        catLanguagelabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(G.share.h(17.5))
            make.left.equalToSuperview().offset(G.share.w(30.29))
            make.right.equalToSuperview().offset(-G.share.w(10.5))
        }
        personLanguagelabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(G.share.h(17.5))
            make.left.equalToSuperview().offset(G.share.w(12.5))
            make.right.equalToSuperview().offset(-G.share.w(30.29))
        }
        audioBtn.snp.makeConstraints { make in
            make.width.equalTo(G.share.w(154.81))
            make.height.equalTo(G.share.h(34))
            make.top.equalToSuperview().offset(G.share.h(25))
            make.left.equalToSuperview().offset(G.share.w(28.2))
        }
    }
    
}