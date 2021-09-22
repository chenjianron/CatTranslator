//
//  SettingVC.swift
//  CatTranslator
//
//  Created by GC on 2021/9/16.
//

import UIKit
import Toolkit
import MessageUI
import SafariServices

class SettingVC: UIViewController {
    
    let CellID = "SettingsViewCell"
    let titles = [[__("修改昵称")],[__("意见反馈")],[__("分享给好友"), __("给个评价"),__("隐私政策"), __("用户协议")]]
    let icons = [["Setting- ChangeName"],["Setting-Help","Setting-Feedback"],["Setting-Share","Setting-Comment","Setting-Policy","Setting-UserAgreement"]]
    
    var bannerView: UIView? {
        return Marketing.shared.bannerView(.settingBanner, rootViewController:self)
    }
    var bannerInset: CGFloat {
        if bannerView != nil {
            return Ad.default.adaptiveBannerHeight
        } else {
            return 0
        }
    }
    lazy var leftBarBtn:UIBarButtonItem = {
        let leftBarBtn = UIBarButtonItem(image: UIImage(named: "Setting-Back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backToPrevious))
        return leftBarBtn
    }()
    lazy var tableView: UITableView = {
        let object = UITableView(frame: .zero, style: .grouped)
        object.delegate = self
        object.dataSource = self
        object.separatorStyle = .none
        object.sectionFooterHeight = .zero
        object.register(SettingTableViewCell.classForCoder(), forCellReuseIdentifier: CellID)
        
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupAdBannerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.popViewController(animated: false)
        Statistics.beginLogPageView("设置页")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Statistics.endLogPageView("设置页")
    }
}

// MARK: - private
extension SettingVC {
    
    func changeName(){
        modalPresentationStyle = .fullScreen
        present(AlertVC(), animated: false, completion: nil)
        Statistics.event(.SettingsTap, label: "修改昵称")
    }
    
    func help(){
        
    }
    
    func feedback(){
        Statistics.event(.SettingsTap, label: "意见反馈")
        if MFMailComposeViewController.canSendMail() {
            FeedbackMailMaker.shared.presentMailComposeViewController(from: self, recipient: K.Share.Email)
        } else {
            let alert = UIAlertController(title: __("未设置邮箱账户"), message: __("要发送电子邮件，请设置电子邮件账户"), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: __("确认"), style: .default, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func share(indexPath:IndexPath){
        Statistics.event(.SettingsTap, label: "分享给好友")
        let content = K.Share.normalContent.toURL()
        let activityVC = UIActivityViewController(activityItems: [content as Any], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popVC = activityVC.popoverPresentationController {
                if let cell = self.tableView.cellForRow(at: indexPath) as? SettingTableViewCell {
                    popVC.sourceView = cell.titleLabel
                }
            }
        }
        activityVC.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if completed {
                Marketing.shared.didShareRT()
            }
        }
        present(activityVC, animated: true, completion: nil)
    }
    
    func comment(){
        Statistics.event(.SettingsTap, label: "给个评价")
        let urlString = "itms-apps://itunes.apple.com/app/id\(K.IDs.AppID)?action=write-review"
        if let url = URL(string: urlString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func policy(){
        Statistics.event(.SettingsTap, label: "隐私政策")
        guard let url = Util.webURL(urlStr: K.Website.PrivacyPolicy) else { return }
        let vc = SFSafariViewController(url: url)
       vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func userAgreement(){
        Statistics.event(.SettingsTap, label: "用户协议")
        guard let url = Util.webURL(urlStr: K.Website.UserAgreement) else { return }
        let vc = SFSafariViewController(url: url)
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - tableView
extension SettingVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            changeName()
        } else if indexPath.section == 1 {
            switch indexPath.row {
                case 0:
                    feedback()
                default:
                    break
                }
        } else if indexPath.section == 2 {
            switch indexPath.row {
                case 0:
                    share(indexPath: indexPath)
                case 1:
                    comment()
                case 2:
                    policy()
                case 3:
                    userAgreement()
                default:
                    break
            }
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SettingTableViewCell = tableView.dequeueReusableCell(withIdentifier:CellID, for: indexPath) as! SettingTableViewCell
        cell.setData(icon: icons[indexPath.section][indexPath.row], title: titles[indexPath.section][indexPath.row])
//        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        headerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(17.21)
            make.centerY.equalToSuperview()
        }
        if section == 0 {
            label.text = __("通用")
        } else if section == 1 {
            label.text = __("帮助与反馈")
        } else {
            label.text = __("关于我们")
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
}

// MARK: - UI
extension SettingVC {
    
    func setupUI(){
        navigationItem.title = __("设置")
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = leftBarBtn
        view.addSubview(tableView)
        setupConstraints()
    }
    
    func setupConstraints(){
        tableView.snp.makeConstraints{ make in
            make.top.equalTo(safeAreaTop).offset(0)
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    func setupAdBannerView() {
        if let bannerView = self.bannerView {
            view.addSubview(bannerView)
            bannerView.snp.makeConstraints { make in
                make.bottom.equalTo(safeAreaBottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(Ad.default.adaptiveBannerHeight)
            }
        }
    }
}

// MARK: - public
extension SettingVC {
    
    @objc func backToPrevious(){
        Statistics.event(.SettingsTap, label: "返回")
        
        let tabbarController = UITabBarController()
        tabbarController.tabBar.barTintColor = UIColor.white
        
        let mainVC = SSNavigationController(rootViewController: MainVC())
        mainVC.tabBarItem.title = __("翻译")
        mainVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: K.Color.ThemeColor], for: .selected)
        mainVC.tabBarItem.image = #imageLiteral(resourceName: "TarBarImage1-Selected")
        mainVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "TarBarImage1")
        tabbarController.addChild(mainVC)
        
        let playCatVC = SSNavigationController(rootViewController: PlayCatVC())
        playCatVC.tabBarItem.title = __("逗猫")
        playCatVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: K.Color.ThemeColor], for: .selected)
        playCatVC.tabBarItem.image = #imageLiteral(resourceName: "TarBarImage2")
        playCatVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "TarBarImage2-Selected")
        tabbarController.addChild(playCatVC)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabbarController
        appDelegate.window?.backgroundColor = .white
        let tabBar = appDelegate.window!.rootViewController as! UITabBarController
        tabBar.selectedIndex = 1
    }
}

extension Util {
    static func webURL(urlStr: String) -> URL? {
        if var urlComponents = URLComponents(string: urlStr) {
            var queryItems = [URLQueryItem]()
            queryItems.append(URLQueryItem(name: "lang", value: Util.languageCode()))
            queryItems.append(URLQueryItem(name: "version", value: Util.appVersion()))
            urlComponents.queryItems = queryItems
            if let url = urlComponents.url {
                return url
            }
        }
        return nil
    }
}
