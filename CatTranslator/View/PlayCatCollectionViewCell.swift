//
//  PlayCatCollectionViewCell.swift
//  CatTranslator
//
//  Created by GC on 2021/9/11.
//

import UIKit
import Toolkit
import AVFoundation

class PlayCatCollectionViewCell: UICollectionViewCell {
    
    private var url:URL?
    private var master: PlayCatVC?
    var player:AVAudioPlayer? //播放器
    var time:Timer?
    
    
    lazy var catHeadView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var audioBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "AudioImage"), for: .normal)
        button.addTarget(self, action: #selector(playRecord), for: .touchUpInside)
        return button
    }()
    lazy var textlabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    lazy var progressView: UIProgressView = {
        let view = UIProgressView(
            progressViewStyle : .default)
        view.isHidden = true
        view.progressTintColor = UIColor.init(hex: 0xFF507C)
        view.trackTintColor = UIColor.white
        return view
    }()
    lazy var audioLogo:UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "Audio-4")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func playRecord(){
        master?.playAudio(cell: self, url: url!)
    }
    
    func changeStatus(){
        textlabel.isHidden = true
        progressView.isHidden = false
        audioBtn.setBackgroundImage(#imageLiteral(resourceName: "Audio-Selected"), for: .normal)
        time = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { (ktimer) in
            self.progressView.progress = Float((self.master?.player!.currentTime)!)/Float((self.master?.player!.duration)!)
        }
    }
    
    func restoreStatus(){
        textlabel.isHidden = false
        progressView.progress = 0
        progressView.isHidden = true
        audioBtn.setBackgroundImage(#imageLiteral(resourceName: "AudioImage"), for: .normal)
        time?.invalidate()
    }
    
    func setUpUI(){
        
        addSubview(audioBtn)
        addSubview(catHeadView)
        
        audioBtn.addSubview(textlabel)
        audioBtn.addSubview(progressView)
        audioBtn.addSubview(audioLogo)
        setUpConstrains()
    }
    
    func setUpDataSource(data: [String:String], master: PlayCatVC){
        catHeadView.image = UIImage(named: data["image"]!)
        textlabel.text = data["text"]
        url = Bundle.main.url(forResource: data["audio"], withExtension: ".wav")
        self.master = master
    }
    
    func setUpConstrains(){
        
        audioBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(G.share.h(40))
        }
        audioLogo.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(G.share.w(16.6))
        }
        catHeadView.snp.makeConstraints { make in
            make.width.equalTo(G.share.w(49))
            make.height.equalTo(G.share.h(40))
            make.bottom.equalTo(audioBtn.snp.bottom).offset(-G.share.h(29.5))
            make.left.equalTo(audioBtn.snp.left).offset(G.share.w(11.21))
        }
        textlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        progressView.snp.makeConstraints{ make in
            make.width.equalTo(G.share.w(100))
            make.height.equalTo(G.share.h(2.57))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(G.share.w(43.4))
        }
    }
}

//MARK: - AVAudioPlayerDelegate
extension PlayCatCollectionViewCell: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully: Bool){
        restoreStatus()
    }
    
}

