//
//  headCollectionVC.swift
//  CatTranslator
//
//  Created by GC on 2021/9/6.
//

import Toolkit
import SnapKit

class HeadCollectionVC: UIViewController {
    
    var type:headType?
    weak var previewPagemaster: PreviewPageVC?
    var indexPageMaster: MainVC?
    
    private let CellID = "CollectionViewCell"
    
    lazy var backgroundBoard:UIView = {
        let view = UIView()
        view.width = Util.isIPad ? 500: 299
        view.height = Util.isIPad ? 467 : 279
        view.layer.cornerRadius = CGFloat(Util.isIPad ? 35 : 14)
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
                                           left: Util.isIPad ? 26 : 13,
                                           bottom: 6,
                                           right: Util.isIPad ? 26 : 13)
        object.scrollDirection = .vertical
        object.minimumLineSpacing =  6
        object.minimumInteritemSpacing = 5
        let count: CGFloat = 3
        let itemWidth = (backgroundBoard.width - (Util.isIPad ? 52 : 26)) / count - 5
        let itemHeight = backgroundBoard.height * 0.33 - 6
        object.itemSize = CGSize(width: itemWidth, height: itemHeight)
        return object
    }()
    lazy var collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(HeadCollectionViewCell.self, forCellWithReuseIdentifier: CellID)
        return collectionView
    }()
    lazy var indexDataSource:[String] = {
        switch type {
        case .cat:
            return [
                "Index-CatHead-1","Index-CatHead-2","Index-CatHead-3","Index-CatHead-4","Index-CatHead-5","Index-CatHead-6","Index-CatHead-7"
            ]
        case .person:
            return [
                "Index-FigureHead-1","Index-FigureHead-2","Index-FigureHead-3","Index-FigureHead-4","Index-FigureHead-5","Index-FigureHead-6"
            ]
        default:
            return [""]
        }
    }()
    lazy var dataSource:[String] = {
        switch type {
        case .cat:
            return [
                "CatHead-1","CatHead-2","CatHead-3","CatHead-4","CatHead-5","CatHead-6","CatHead-7"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if type == .cat {
            Statistics.beginLogPageView("修改猫咪图片页")
        } else {
            Statistics.beginLogPageView("修改人物图片页")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if type == .cat {
            Statistics.endLogPageView("修改猫咪图片页")
        } else {
            Statistics.endLogPageView("修改人物图片页")
        }
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
        if previewPagemaster != nil {
            previewPagemaster?.dismiss(animated: true, completion: nil)
        } else {
            indexPageMaster?.dismiss(animated: true, completion: nil)
        }
        
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
        if previewPagemaster != nil {
            switch type {
            case .cat:
                previewPagemaster?.setCatName(indexDataSource[indexPath.row])
            case .person:
                previewPagemaster?.setPersonName(indexDataSource[indexPath.row])
            default:
                break
            }
        } else {
            switch type {
            case .cat:
                indexPageMaster?.setCatName(indexDataSource[indexPath.row])
            case .person:
                indexPageMaster?.setPersonName(indexDataSource[indexPath.row])
            default:
                break
            }
        }
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
            make.top.equalToSuperview().offset(Util.isIPad ? 54 : 35)
            make.centerX.equalToSuperview()
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLable.snp.bottom).offset(G.share.h(16.5))
            make.bottom.equalToSuperview().offset(Util.isIPad ? -52 : -27)
            make.left.right.equalToSuperview()
        }
    }
    
}
