//
//  headCollectionVC.swift
//  CatTranslator
//
//  Created by GC on 2021/9/6.
//

import Toolkit
import SnapKit

class HeadCollectionVC: UIViewController {
    
    var master: UIViewController?
    var type:headType?
    
    private let CellID = "CollectionViewCell"
    
    lazy var backgroundBoard:UIView = {
        let view = UIView()
        view.layer.cornerRadius = CGFloat(G.share.w(14))
        view.layer.masksToBounds = false
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    lazy var cancelBtn:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Close"), for: .normal)
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    lazy var titleLable:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = __("更换图片")
        return label
    }()
    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let object = UICollectionViewFlowLayout()
        object.sectionInset = UIEdgeInsets(top: 0,
                                           left: 0,
                                           bottom: 0,
                                           right: 0)
        object.scrollDirection = .vertical
        object.minimumLineSpacing = 5
        object.minimumInteritemSpacing = 5
        let count: CGFloat = 3
        let itemWidth = (backgroundBoard.width - 5) / count - 5
        let itemHeight = backgroundBoard.height * 0.29 - 5
        object.itemSize = CGSize(width: itemWidth, height: itemHeight)
        return object
    }()
    lazy var collectionView : UICollectionView = {
        let object = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        object.showsHorizontalScrollIndicator = false
        object.showsVerticalScrollIndicator = true
        object.delegate = self
        object.dataSource = self
        object.backgroundColor = .white
        object.register(HeadCollectionViewCell.self, forCellWithReuseIdentifier: CellID)
        return object
    }()
    lazy var dataSource:[String] = {
        switch type {
        case .cat:
            return [
                "CatHead-5","CatHead-9","CatHead-7","CatHead-10","CatHead-2","CatHead-4","CatHead-1","CatHead-3","CatHead-6","CatHead-8"
            ]
        case .person:
            return [
                "FigureHead-1","FigureHead-2","FigureHead-3","FigureHead-4","FigureHead-5","FigureHead-6"
            ]
        default:
            return [""]
        }
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

}

//MARK: - private
extension HeadCollectionVC {
    
    func showAnimate() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            UIView.animate(withDuration: 0.3) {
                self.view.backgroundColor = UIColor.init(hex: 0x000000, alpha: 0.3)
            }
        }
    }
    
    func dismissAnimate(complete: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = .clear
        } completion: { _ in
            complete()
        }
    }
    
    @objc func cancel(){
        master?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CollectionView
extension HeadCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath)
        if let headerCell = cell as? HeadCollectionViewCell {
            headerCell.type = type
            headerCell.headView.image = UIImage(named: dataSource[indexPath.row])
      
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

//MARK: - UI
extension HeadCollectionVC {
    
    func setUpUI(){
        view.addSubview(backgroundBoard)
        backgroundBoard.addSubview(cancelBtn)
        backgroundBoard.addSubview(titleLable)
        backgroundBoard.addSubview(collectionView)
        setUpConstrains()
        showAnimate()
    }
    
    func setUpConstrains(){
        backgroundBoard.snp.makeConstraints{ make in
            make.width.equalTo(Util.isIPad ? 500: 299)
            make.height.equalTo(Util.isIPad ? 467 : 279)
            make.top.equalToSuperview().offset(G.share.h(268.66))
            make.centerX.equalToSuperview()
        }
        cancelBtn.snp.makeConstraints{ (make) in
            make.width.equalTo(Util.isIPad ? 40 : 24)
            make.height.equalTo(Util.isIPad ? 40 : 24)
            make.top.equalToSuperview().offset(Util.isIPad ? 20 : 12)
            make.right.equalToSuperview().offset(Util.isIPad ? -15.8 :  -9.57)
        }
        titleLable.snp.makeConstraints{ (make) in
            make.width.equalTo(Util.isIPad ? 134 : 80)
            make.height.equalTo(Util.isIPad ? 33.4 : 22)
            make.top.equalToSuperview().offset(Util.isIPad ? 59 : 35)
            make.centerX.equalToSuperview()
        }
        collectionView.snp_makeConstraints { (make) in
            make.top.equalTo(titleLable).offset(20)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
}
