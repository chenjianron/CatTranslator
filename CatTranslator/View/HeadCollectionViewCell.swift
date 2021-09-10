//
//  HeadCollectionView.swift
//  CatTranslator
//
//  Created by GC on 2021/9/7.
//

import UIKit
import SnapKit

class HeadCollectionViewCell: UICollectionViewCell {
    
    var type:headType?{
        didSet {
            self.setUpUI()
        }
    }
    
    lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var headView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI(){
        
        addSubview(backgroundImage)
        backgroundImage.addSubview(headView)
        
        backgroundImage.snp.makeConstraints{ make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        headView.snp.makeConstraints{ make in
            switch type {
            case .cat:
                make.width.equalToSuperview().multipliedBy(0.875)
                make.height.equalToSuperview().multipliedBy(0.716)
                backgroundImage.image = #imageLiteral(resourceName: "CatHeadBackground")
            case .person:
                make.width.equalToSuperview().multipliedBy(0.68)
                make.height.equalToSuperview().multipliedBy(0.91)
                make.bottom.equalToSuperview()
                backgroundImage.image = #imageLiteral(resourceName: "PersonHeadBackground")
            default:
                break
            }
            make.center.equalToSuperview()
        }
    }
}
