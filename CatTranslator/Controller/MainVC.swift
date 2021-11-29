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
    
    var url:URL?
    var player:AVAudioPlayer?
    var catTimer:Timer?
    var personTimer:Timer?
    
    var bannerView: UIView? {
        return Marketing.shared.bannerView(.homeBanner, rootViewController:self)
    }
    var bannerInset: CGFloat {
        if bannerView != nil {
            return Ad.default.adaptiveBannerHeight
        } else {
            return 0
        }
    }
    
    let audio = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    
    var catHeadName = UserDefaults.standard.value(forKey: "CatHeadName") ?? "Index-CatHead-7"{
        didSet {
            self.catImageView.headView.image = UIImage(named: catHeadName as! String)
            UserDefaults.standard.setValue(catHeadName, forKey: "CatHeadName")
        }
    }
    var personHeadName = UserDefaults.standard.value(forKey: "PersonHeadName") ?? "Index-FigureHead-2"{
        didSet {
            self.personImageView.headView.image = UIImage(named: personHeadName as! String)
            UserDefaults.standard.setValue(personHeadName, forKey: "PersonHeadName")
        }
    }
    var catName = __((UserDefaults.standard.value(forKey: "CatName") ?? "猫咪") as! String)
    var first:Bool = true
//    var index:Int = 0
//    var text:String = ""
    
    lazy var record:RTMAudioRecord? = {
        let record = RTMAudioRecord()
       return record
    }()
    lazy var catBackgroundBoard: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(hex: 0xE3F7FE)
        imageView.layer.cornerRadius = G.share.w(10)
//        imageView.image = #imageLiteral(resourceName: "CatHeadBackground")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var personBackgroundBoard: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(hex: 0xFEF2F4)
        imageView.layer.cornerRadius = G.share.w(10)
//        imageView.image = #imageLiteral(resourceName: "PersonHeadBackground")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var catLanguageBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = #imageLiteral(resourceName: "CatLanguageBackground")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var personLanguageBackground: UIImageView = {
        let imageView = UIImageView()
        if !Util.isIPad {
            imageView.contentMode = .scaleAspectFill
        }
        imageView.image = #imageLiteral(resourceName: "PersonLanguageBackground")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var catImageView:HeadView = {
        let headView = HeadView(frame: .zero, type: .cat)
        headView.indexPageMaster = self
        headView.headView.image = UIImage(named: catHeadName as! String)
        return headView
    }()
    lazy var personImageView:HeadView = {
        let headView = HeadView(frame: .zero, type: .person)
        headView.indexPageMaster = self
        headView.headView.image = UIImage(named: personHeadName as! String)
        return headView
    }()
    lazy var catRecordBtn:UIButton = {
        let button = UIButton()
        button.adjustsImageWhenHighlighted = false
        button.tag = 1
        button.setImage(#imageLiteral(resourceName: "CatRecordBtn"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(recordAuthority(button:)), for: .touchDown)
        button.addTarget(self, action: #selector(catRecord), for: .touchUpInside)
        button.addTarget(self, action: #selector(catRecord), for: .touchUpOutside)
        return button
    }()
    lazy var personRecordBtn:UIButton = {
        let button = UIButton()
        button.adjustsImageWhenHighlighted = false
        button.tag = 2
        button.setImage(#imageLiteral(resourceName: "PersonRecordBtn"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(recordAuthority(button:)), for: .touchDown)
        button.addTarget(self, action: #selector(personRecord), for: .touchUpInside)
        button.addTarget(self, action: #selector(personRecord), for: .touchUpOutside)
        return button
    }()
    lazy var catBtnlabel: UILabel = {
        let label = UILabel()
        label.text = __("长按")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    lazy var personBtnlabel: UILabel = {
        let label = UILabel()
        label.text = __("长按")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    lazy var catLanguagelabel: UILabel = {
        let label = UILabel()
        label.text = __("请长按录制猫语…")
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
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
        button.contentMode = .scaleAspectFill
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(firstPlay), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    lazy var audioLogo:UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 13))
        view.contentMode = .scaleToFill
        view.animationImages = [UIImage(named: "Index-AudioLogo-1"),UIImage(named: "Index-AudioLogo-2"),UIImage(named: "Index-AudioLogo-3"),UIImage(named: "Index-AudioLogo-4")].compactMap{$0}
        view.animationDuration = 1
        view.animationRepeatCount = 0
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        view.image = #imageLiteral(resourceName: "Index-AudioLogo")
        return view
    }()
    lazy var audioLable:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = K.Color.ThemeColor
        return label
    }()
    lazy var catRecordRightLogo:UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 22))
        view.animationImages = [UIImage(named: "CatRecordRightLogo-1"),UIImage(named: "CatRecordRightLogo-2"),UIImage(named: "CatRecordRightLogo-3"),UIImage(named: "CatRecordRightLogo-4")].compactMap{$0}
        view.animationDuration = 1
        view.animationRepeatCount = 0
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    lazy var catRecordLeftLogo:UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 22))
        view.animationImages = [UIImage(named: "CatRecordLeftLogo-1"),UIImage(named: "CatRecordLeftLogo-2"),UIImage(named: "CatRecordLeftLogo-3"),UIImage(named: "CatRecordLeftLogo-4")].compactMap{$0}
        view.animationDuration = 1
        view.animationRepeatCount = 0
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    lazy var personRecordRightLogo:UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 22))
        view.animationImages = [UIImage(named: "PersonRecordRightLogo-1"),UIImage(named: "PersonRecordRightLogo-2"),UIImage(named: "PersonRecordRightLogo-3"),UIImage(named: "PersonRecordRightLogo-4")].compactMap{$0}
        view.animationDuration = 1
        view.animationRepeatCount = 0
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    lazy var personRecordLeftLogo:UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 22))
        view.animationImages = [UIImage(named: "PersonRecordLeftLogo-1"),UIImage(named: "PersonRecordLeftLogo-2"),UIImage(named: "PersonRecordLeftLogo-3"),UIImage(named: "PersonRecordLeftLogo-4")].compactMap{$0}
        view.animationDuration = 1
        view.animationRepeatCount = 0
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    lazy var catScrollView:UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setupAdBannerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Statistics.beginLogPageView("首页")
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Statistics.endLogPageView("首页")
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        if player != nil && player!.isPlaying == true {
            player?.stop()
            audioLogo.stopAnimating()
        }
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
    
    func catTextAnimating(array:Array<Character>){
        var index:Int = 0
        var text:String = ""
        let string = array
        if(catTimer != nil){
            catTimer?.invalidate()
            catTimer = nil
        }
        catTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [self] make in
            text += String(string[index])
            if Thread.current.isMainThread {
                catLanguagelabel.text = text
            } else {
                    // 切换到 main 线程，处理
                    DispatchQueue.main.async {
                        catLanguagelabel.text = text
                        // 结束事件，防止造成递归循环
                        return
                    }
                }
            index += 1
            if index == string.count {
                index = 0
                text = ""
                catTimer?.invalidate()
                catTimer = nil
            }
        })
    }
    
    func personTextAnimating(array:Array<Character>){
        var index:Int = 0
        var text:String = ""
        let string = array
        if(personTimer != nil){
            personTimer?.invalidate()
            personTimer = nil
        }
        personTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [self] make in
            text += String(string[index])
            personLanguagelabel.text = text
            index += 1
            if index == string.count {
                index = 0
                text = ""
                personTimer?.invalidate()
                personTimer = nil
            }
        })
    }
    
    //判断猫录音后的录音时长和音量
    func judgeCatRecord(){
        let ctx = Ad.default.interstitialSignal(key: K.ParamName.RecordInterstitial)
        record!.upAction()
        ctx.didEndAction = { [self] _ in
            guard let recorder = record?.recorder else {
                return
            }
            if recorder.currentTime <= 3 {
                catTextAnimating(array: Array( __("录制时间太短，请录制3s以上哦..")))
                return
            }
            print(recorder.peakPower(forChannel: 0))
            if (recorder.peakPower(forChannel: 0)) < -40 {
                catTextAnimating(array: Array( __("没有听清猫猫的声音哦..")))
                return
            }
            catTextAnimating(array: Array( catName as! String + ": " + Quotations[Int.random(in: 0...49)]))
            Marketing.shared.didCatTranslatorRT()
        }
    }
    
    //判断人录音后的录音时长和音量
    func judgePersonRecord(){
        let ctx = Ad.default.interstitialSignal(key: K.ParamName.RecordInterstitial)
        record!.upAction()
        ctx.didEndAction = { [self] _ in
            guard let recorder = record?.recorder else {
                return
            }
            print(record!.recorder!.peakPower(forChannel: 0))
            if recorder.currentTime <= 3 {
                personTextAnimating(array: Array(__("录制时间太短，请录制3s以上哦..")))
                return
            }
            if (recorder.peakPower(forChannel: 0)) < -40 {
                personTextAnimating(array: Array(__("声音太小啦，没有听清…")))
                return
            }
            personLanguageBackground.isHidden = true
            guard let url = Bundle.main.url(forResource: audio[Int.random(in: 0...19)], withExtension: ".mp3") else {
                return
            }
            self.url  = url
            player = try! AVAudioPlayer(contentsOf: self.url!)
            audioLable.text = Int(player!.duration).description + "″"
            audioBtn.isHidden = false
            audioBtn.isUserInteractionEnabled = true
            first = true
        }
    }
    
    //判断是哪一个录音按钮点击了
    func judgeBtn(button:UIButton){
        if button.tag == 1 {
            Statistics.event(.HomePageTap, label: "猫录音键")
            self.catRecordTouchDown()
        }else {
            Statistics.event(.HomePageTap, label: "人录音键")
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
            catRecordRightLogo.startAnimating()
            catRecordLeftLogo.startAnimating()
        }else {
            catRecordRightLogo.stopAnimating()
            catRecordLeftLogo.stopAnimating()
        }
        catTextAnimating(array: Array(__("正在聆听猫猫说话…")))
        catImageView.headView.isUserInteractionEnabled = status
        personRecordBtn.isUserInteractionEnabled = status
        personImageView.isUserInteractionEnabled = status
        getRootViewController()!.view.isUserInteractionEnabled = status
    }
    
    func personRecordBtnStatus(status:Bool){
        if personLanguageBackground.isHidden == true {
            if player?.isPlaying == true {
                player?.stop()
            }
            first = true
            audioLogo.stopAnimating()
            audioBtn.isHidden = true
            personLanguageBackground.isHidden = false
        }
        if !status {
            personRecordRightLogo.startAnimating()
            personRecordLeftLogo.startAnimating()
        } else {
            personRecordRightLogo.stopAnimating()
            personRecordLeftLogo.stopAnimating()
//            personRecordBtn.setImage(#imageLiteral(resourceName: "PersonRecordBtn"), for: .normal)
        }
        personTextAnimating(array: Array(__("正在为您翻译…")))
        personImageView.headView.isUserInteractionEnabled = status
        catImageView.headView.isUserInteractionEnabled = status
        catRecordBtn.isUserInteractionEnabled = status
        getRootViewController()!.view.isUserInteractionEnabled = status
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
        if(!UserDefaults.standard.bool(forKey: "FirstLaunchMainDown")){
            UserDefaults.standard.setValue(true, forKey: "FirstLaunchMainDown")
        } else {
            catRecordBtnStatus(status: false)
            record!.downAction()
        }
    }
    @objc func catRecord(){
        if(!UserDefaults.standard.bool(forKey: "FirstLaunchMainUp")){
            UserDefaults.standard.setValue(true, forKey: "FirstLaunchMainUp")
        } else {
            catRecordBtnStatus(status: true)
            judgeCatRecord()
        }
    }
    @objc func personRecordTouchDown(){
        if(UserDefaults.standard.bool(forKey: "FirstLaunchMainDown")){
            personRecordBtnStatus(status: false)
            record!.downAction()
        } else {
            UserDefaults.standard.setValue(true, forKey: "FirstLaunchMainDown")
        }
    }
    @objc func personRecord(){
        if(UserDefaults.standard.bool(forKey: "FirstLaunchMainUp")){
            personRecordBtnStatus(status: true)
            judgePersonRecord()
        } else {
            UserDefaults.standard.setValue(true, forKey: "FirstLaunchMainUp")
        }
    }
    // 首次播放人语转猫语的录音
    @objc func firstPlay(){
        if first {
            audioBtn.isUserInteractionEnabled = false
            catRecordBtn.isUserInteractionEnabled = false
            player?.play()
            player?.delegate = self
            audioLogo.startAnimating()
        } else {
            Statistics.event(.HomePageTap, label: "回放")
            if player?.isPlaying == true {
                catRecordBtn.isUserInteractionEnabled = true
                player?.stop()
                audioLogo.stopAnimating()
            } else {
                catRecordBtn.isUserInteractionEnabled = false
                player?.play()
                audioLogo.startAnimating()
            }
        }
    }
}

//MARK: - AVAudioPlayerDelegate
extension MainVC: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully: Bool){
        if first {
            audioBtn.isUserInteractionEnabled = true
            catRecordBtn.isUserInteractionEnabled = true
            first = false
            audioLogo.stopAnimating()
        } else {
            catRecordBtn.isUserInteractionEnabled = true
            audioLogo.stopAnimating()
        }
    }
    
}

//MARK: - UI
extension MainVC {
    
    func setupAdBannerView() {
        if let bannerView = self.bannerView {
            view.addSubview(bannerView)
            bannerView.snp.makeConstraints { make in
                make.top.equalTo(safeAreaTop)
                make.left.right.equalToSuperview()
                make.height.equalTo(Ad.default.adaptiveBannerHeight)
            }
        }
    }
    
    func setUpUI(){
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.title = __("翻译器")
        view.addSubview(catBackgroundBoard)
        view.addSubview(personBackgroundBoard)
        catBackgroundBoard.addSubview(catImageView)
        catBackgroundBoard.addSubview(catLanguageBackground)
        catLanguageBackground.addSubview(catScrollView)
        catScrollView.addSubview(catLanguagelabel)
        catBackgroundBoard.addSubview(catRecordBtn)
        catRecordBtn.addSubview(catRecordRightLogo)
        catRecordBtn.addSubview(catRecordLeftLogo)
        catBackgroundBoard.addSubview(catBtnlabel)
//        catLanguageBackground.addSubview(catLanguagelabel)
        
        personBackgroundBoard.addSubview(personLanguageBackground)
        personBackgroundBoard.addSubview(personImageView)
        personBackgroundBoard.addSubview(personRecordBtn)
        personRecordBtn.addSubview(personRecordRightLogo)
        personRecordBtn.addSubview(personRecordLeftLogo)
        personBackgroundBoard.addSubview(personBtnlabel)
        personBackgroundBoard.addSubview(personLanguagelabel)
        personBackgroundBoard.addSubview(audioBtn)
        
        personLanguageBackground.addSubview(personLanguagelabel)
        audioBtn.addSubview(audioLable)
        audioBtn.addSubview(audioLogo)
        setUpConstrains()
    }
    
    func setUpConstrains(){
        
        catBackgroundBoard.snp.makeConstraints{ make in
            make.width.equalTo( G.share.w(332))
            make.height.equalTo(G.share.h(231))
            make.top.equalTo(safeAreaTop).offset(G.share.h(30)+bannerInset)
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
            make.height.equalTo( G.share.h(103))
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
            make.width.equalTo(63)
            make.height.equalTo(G.share.h(41))
            make.bottom.equalTo(-35.5)
            make.centerX.equalToSuperview()
        }
        personRecordBtn.snp.makeConstraints{ make in
            make.width.equalTo(63)
            make.height.equalTo(G.share.h(41))
            make.bottom.equalTo(-35.5)
            make.centerX.equalToSuperview()
        }
        catBtnlabel.snp.makeConstraints { make in
            make.bottom.equalTo(-G.share.h(12))
            make.centerX.equalToSuperview()
        }
        personBtnlabel.snp.makeConstraints { make in
//            make.width.equalTo(G.share.w(24))
//            make.height.equalTo(G.share.h(17))
            make.bottom.equalTo(-G.share.h(12))
            make.centerX.equalToSuperview()
        }
        catScrollView.snp.makeConstraints{ make in
            make.width.equalTo(G.share.w(120))
            make.top.equalToSuperview().offset(G.share.h(17.5))
            make.left.equalToSuperview().offset(G.share.w(30.29))
            make.right.equalToSuperview().offset(-G.share.w(10.5))
            make.height.equalTo(G.share.h(85))
        }
        catLanguagelabel.snp.makeConstraints{ make in
            make.width.equalTo(G.share.w(120))
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(0)
        }
        personLanguagelabel.snp.makeConstraints{ make in
            make.width.equalTo(G.share.w(120))
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
        audioLable.snp.makeConstraints{ make in
            make.height.equalTo(G.share.h(17))
            make.left.equalTo(G.share.w(25.31))
            make.centerY.equalToSuperview()
        }
        audioLogo.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(G.share.w(11))
        }
        catRecordRightLogo.snp.makeConstraints{ make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        catRecordLeftLogo.snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        personRecordRightLogo.snp.makeConstraints{ make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        personRecordLeftLogo.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
    }
    
}
