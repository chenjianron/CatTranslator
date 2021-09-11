//
//  PlayCatCollectionViewCell.swift
//  CatTranslator
//
//  Created by GC on 2021/9/11.
//

import UIKit
import SnapKit

class PlayCatCollectionViewCell: UICollectionViewCell {
    
    lazy var catHeadView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var audioBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "SaveBackground"), for: .normal)
        return button
    }()
    lazy var audioLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "RecordLogo")
        return imageView
    }()
    lazy var textlabel:UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var progressView: UIProgressView = {
        let view = UIProgressView(
            progressViewStyle : .default)
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI(){
        
        addSubview(audioBtn)
        addSubview(catHeadView)
        
        audioBtn.addSubview(audioLogo)
        audioBtn.addSubview(textlabel)
        audioBtn.addSubview(progressView)
        setUpConstrains()
    }
    
    func setUpConstrains(){
        
        audioBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalTo(G.share.w(160))
            make.height.equalTo(G.share.h(40))
        }
        catHeadView.snp.makeConstraints { make in
            make.width.equalTo(G.share.w(47.5))
            make.height.equalTo(G.share.h(39.5))
            make.bottom.equalTo(audioBtn.snp.bottom).offset(-G.share.h(29.5))
        }
        audioLogo.snp.makeConstraints{ make in
            make.width.equalTo(G.share.w(18))
            make.height.equalTo(G.share.h(13))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(G.share.w(16.6))
        }
        textlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        progressView.snp.makeConstraints{ make in
            make.width.equalTo(G.share.w(100))
            make.height.equalTo(G.share.h(2.57))
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(G.share.w(43.4))
        }
    }
}

