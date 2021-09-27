//
//  HeadView.swift
//  CatTranslator
//
//  Created by GC on 2021/9/5.
//

import UIKit
import SnapKit

class HeadView: UIView {
    
    var type:headType?
    weak var previewPagemaster: PreviewPageVC?{
        didSet {
            switch type {
            case .cat:
                self.headView.image = #imageLiteral(resourceName: "Index-CatHead-7")
            case .person:
                self.headView.image = #imageLiteral(resourceName: "Index-FigureHead-2")
            default:
                break
            }
        }
    }
    var indexPageMaster: MainVC? {
        didSet {
            switch type {
            case .cat:
                self.headView.image = #imageLiteral(resourceName: "Index-CatHead-7")
            case .person:
                self.headView.image = #imageLiteral(resourceName: "Index-FigureHead-2")
            default:
                break
            }
        }
    }
    
    lazy var headView: UIImageView = {
        let imageView = UIImageView()
        switch type {
        case .cat:
            if !UserDefaults.standard.bool(forKey: "CatHeadName"){
                imageView.image = #imageLiteral(resourceName: "Index-CatHead-7")
            } else {
                imageView.image = UIImage(named: UserDefaults.standard.value(forKey: "CatHeadName") as! String)
            }
        case .person:
            if !UserDefaults.standard.bool(forKey: "PersonHeadName"){
                imageView.image = #imageLiteral(resourceName: "Index-FigureHead-2")
            } else {
                imageView.image = UIImage(named: UserDefaults.standard.value(forKey: "PersonHeadName") as! String)
            }
        default:
            break
        }
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHead)))
        return imageView
    }()
    
    init(frame: CGRect,type: headType) {
        super.init(frame: frame)
        self.type = type
        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI(){
        
        addSubview(headView)
        
        headView.snp.makeConstraints{ make in
            switch type {
            case .cat:
                make.width.equalTo(G.share.h(110))
                make.height.equalTo(G.share.h(110))
            case .person:
                make.width.equalTo(G.share.h(110.68))
                make.height.equalTo(G.share.h(110.68))
            default:
                break
            }
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    @objc func selectHead(){
        if previewPagemaster != nil {
            switch type {
            case .cat:
                Statistics.event(.HomePageTap, label: "修改猫咪图片页")
                let headCollectionVC = HeadCollectionVC()
                headCollectionVC.type = .cat
                headCollectionVC.previewPagemaster = previewPagemaster
                previewPagemaster!.present(headCollectionVC, animated: true, completion: nil)
            case .person:
                Statistics.event(.HomePageTap, label: "修改人物图片页")
                let headCollectionVC = HeadCollectionVC()
                headCollectionVC.type = .person
                headCollectionVC.previewPagemaster = previewPagemaster
                previewPagemaster!.present(headCollectionVC, animated: true, completion: nil)
            default:
                break
            }
        } else {
            switch type {
            case .cat:
                Statistics.event(.HomePageTap, label: "修改猫咪图片页")
                let headCollectionVC = HeadCollectionVC()
                headCollectionVC.type = .cat
                headCollectionVC.indexPageMaster = indexPageMaster
                indexPageMaster?.present(headCollectionVC, animated: true, completion: nil)
            case .person:
                Statistics.event(.HomePageTap, label: "修改人物图片页")
                let headCollectionVC = HeadCollectionVC()
                headCollectionVC.type = .person
                headCollectionVC.indexPageMaster = indexPageMaster
                indexPageMaster?.present(headCollectionVC, animated: true, completion: nil)
            default:
                break
            }
        }
    }
}
