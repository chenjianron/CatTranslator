//
//  ContainerVC.swift
//  CatTranslator
//
//  Created by GC on 2021/9/10.
//

import UIKit
import Toolkit
import AVFoundation

class PlayCatVC: UIViewController {
    
    private let CellID = "PlayCatCollectionViewCell"
    
    var playCatCollectionView: PlayCatCollectionViewCell?
    var url:URL?
    var player:AVAudioPlayer?
    
    var bannerView: UIView? {
        return Marketing.shared.bannerView(.PlayCatBanner, rootViewController:self)
    }
    var bannerInset: CGFloat {
        if bannerView != nil {
            return Ad.default.adaptiveBannerHeight
        } else {
            return 0
        }
    }
    
    lazy var dataSource:[[[String:String]]] = {
        return [
            [
                ["image":"Happy","text":__("开心"),"audio":"开心"],
                ["image":"SaJiao","text":__("撒娇"),"audio":"撒娇"],
                ["image":"MaiMeng","text":__("卖萌"),"audio":"卖萌"],
                ["image":"HaoQi","text":__("好奇"),"audio":"好奇"],
                ["image":"TaoYan","text":__("讨厌"),"audio":"讨厌"],
                ["image":"FengNu","text":__("愤怒"),"audio":"愤怒"],
                ["image":"WeiQu","text":__("委屈"),"audio":"委屈"],
                ["image":"DaHuLu","text":__("打呼噜"),"audio":"呼噜声"],
            ],
            [
                ["image":"JiE","text":__("饥饿"),"audio":"饥饿"],
                ["image":"GouGouTiaoXin","text":__("狗狗挑衅"),"audio":"狗狗挑衅"],
                ["image":"ZhaMao","text":__("炸毛"),"audio":"炸毛"],
                ["image":"QiangShiWu","text":__("抢食物"),"audio":"抢食物"],
                ["image":"Wei","text":__("喂！"),"audio":"喂"],
                ["image":"QiuAnWei","text":__("求安慰"),"audio":"求安慰"],
            ]
        ]
    }()
    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: G.share.h(14),
                                           left: G.share.w(20),
                                           bottom: G.share.h(29.9),
                                           right: G.share.w(20))
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing =  G.share.h(13)
        layout.minimumInteritemSpacing = G.share.w( 15.7)
        let count: CGFloat =  2
        let itemWidth = ( ScreenWidth - G.share.w((40)) ) / count - CGFloat(G.share.w(7.9))
        let itemHeight =  G.share.h(70.5)
        layout.headerReferenceSize = CGSize(width: CGFloat(200), height: 35.5)
        layout.itemSize = CGSize(width: CGFloat(itemWidth), height: CGFloat(itemHeight))
        return layout
    }()
    lazy var collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white

        collectionView.register(PlayCatCollectionViewCell.self, forCellWithReuseIdentifier: CellID)
        collectionView.register(
          UICollectionReusableView.self,
          forSupplementaryViewOfKind:
            UICollectionView.elementKindSectionHeader,
          withReuseIdentifier: "Header")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setupAdBannerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Statistics.beginLogPageView("逗猫页")
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Statistics.endLogPageView("逗猫页")
        if(player?.isPlaying == true) {
            player?.stop()
            playCatCollectionView?.restoreStatus()
        }
    }
}
//MARK: - Public
extension PlayCatVC:PlayCatCollectionViewCellDelegate {
    
    func playAudio(cell: PlayCatCollectionViewCell, url: URL, type: Int) {
        if(type == 0){
            Statistics.event(.HomePageTap, label: "任意心情音频")
        } else {
            Statistics.event(.HomePageTap, label: "任意日常音频")
        }
        if playCatCollectionView == cell {
            sameCell()
        } else {
            differentCell(cell: cell, url: url)
        }
    }
}

//MARK: - Private
extension PlayCatVC {
    
     func sameCell(){
        if player?.isPlaying == true {
            player?.stop()
            playCatCollectionView?.restoreStatus()
        } else {
            differentCell(cell: playCatCollectionView!, url: url!)
        }
     }
    
     func differentCell(cell:PlayCatCollectionViewCell,url:URL){
        if player?.isPlaying == true {
            player?.stop()
            playCatCollectionView?.restoreStatus()
        }
        playCatCollectionView = cell
        self.url = url
        player = try! AVAudioPlayer(contentsOf: url)
        player!.delegate = playCatCollectionView
        player!.play()
        playCatCollectionView?.changeStatus()
     }
    
}

//MARK: - Interaction
extension PlayCatVC {
    
    @objc func setting(){
        Statistics.event(.HomePageTap, label: "设置页")
        let viewController = SSNavigationController(rootViewController: SettingVC())
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = viewController
        appDelegate.window?.backgroundColor = .white
//        self.navigationController?.pushViewController(SettingVC(),animated: false)
    }
}

// MARK: - CollectionView
extension PlayCatVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath)
        if let headerCell = cell as? PlayCatCollectionViewCell {
            headerCell.setUpDataSource(data: dataSource[indexPath.section][indexPath.row],master: self, type: indexPath.section)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            
            Statistics.event(.HomePageTap, label: "任意心情音频")
        } else {
            
            Statistics.event(.HomePageTap, label: "任意日常音频")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView = UICollectionReusableView()
        let label = UILabel(frame: CGRect(x: G.share.w(30.5), y: 15.5,width: 100, height: 20))
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        if kind == UICollectionView.elementKindSectionHeader {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,withReuseIdentifier: "Header",for: indexPath)
            reusableView.backgroundColor = UIColor.white
            if indexPath.section == 0 {
                label.text = __("心情");
            } else {
                label.text = __("日常")
            }
        }
        reusableView.addSubview(label)
        return reusableView
    }
}


//MARK: - UI
extension PlayCatVC {
    
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
        navigationItem.title = __("逗猫")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "SettingIcon"), style: .plain, target: self, action: #selector(setting))
        view.addSubview(collectionView)
        setUpConstrains()
    }
    
    func setUpConstrains(){
        collectionView.snp.makeConstraints{ make in
            make.height.equalToSuperview().multipliedBy(0.91).offset(-bannerInset)
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaTop).offset(bannerInset)
        }
    }
}
