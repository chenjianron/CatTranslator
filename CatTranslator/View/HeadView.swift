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
    var master: UIViewController?
    
    lazy var emptyView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHead)))
       return view
    }()
    lazy var backgroundView: UIImageView = {
        let imageView = UIImageView()
        switch type {
        case .cat:
            imageView.image = #imageLiteral(resourceName: "CatBackground")
        case .person:
            imageView.image = #imageLiteral(resourceName: "PersonBackground")
        default:
            break
        }
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var headView: UIImageView = {
        let imageView = UIImageView()
        switch type {
        case .cat:
            if !UserDefaults.standard.bool(forKey: "Cat"){
                imageView.image = #imageLiteral(resourceName: "CatHead-8")
            } else {
                imageView.image = UIImage(named: UserDefaults.standard.value(forKey: "Cat") as! String)
            }
        case .person:
            if !UserDefaults.standard.bool(forKey: "Person"){
                imageView.image = #imageLiteral(resourceName: "FigureHead-7")
            } else {
                imageView.image = UIImage(named: UserDefaults.standard.value(forKey: "Person") as! String)
            }
        default:
            break
        }
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHead)))
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI(){
        
        addSubview(emptyView)
        emptyView.addSubview(backgroundView)
        backgroundView.addSubview(headView)
        
        emptyView.snp.makeConstraints{ make in
            make.width.equalTo(G.share.h(110.68))
            make.height.equalTo(G.share.h(110.68))
        }
        backgroundView.snp.makeConstraints{ make in
            make.width.equalTo(G.share.h(110.68))
            make.height.equalTo(G.share.h(110.68))
        }
        headView.snp.makeConstraints{ make in
            switch type {
            case .cat:
                make.width.equalTo(G.share.h(80.55))
                make.height.equalTo(G.share.h(75.67))
                make.top.equalToSuperview().offset(G.share.h(28.33))
            case .person:
                make.width.equalTo(G.share.h(69.96))
                make.height.equalTo(G.share.h(86.5))
                make.top.equalToSuperview().offset(G.share.h(18))
            default:
                break
            }
            make.centerX.equalToSuperview()
        }
    }
    
    func setType(_ type: headType){
        self.type = type
        setUpUI()
    }
    
    @objc func selectHead(){
        switch type {
        case .cat:
            let headCollectionVC = HeadCollectionVC()
            headCollectionVC.type = .cat
            headCollectionVC.master = master
            master!.present(headCollectionVC, animated: false, completion: nil)
        case .person:
            let headCollectionVC = HeadCollectionVC()
            headCollectionVC.type = .person
            headCollectionVC.master = master
            master!.present(headCollectionVC, animated: false, completion: nil)
        default:
            break
        }
    }
}
