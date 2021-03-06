//
//  RTMAudioRecord.swift
//  CatTranslator
//
//  Created by GC on 2021/9/8.
//

import UIKit
import AVFoundation
import Toolkit
 
class RTMAudioRecord: NSObject{
     
    var recorder:AVAudioRecorder? //录音器
    var player:AVAudioPlayer? //播放器
    var recorderSeetingsDic:[String : Any]? //录音器设置参数数组
    var volumeTimer:Timer? //定时器线程，循环监测录音的音量大小
    var aacPath:String? //录音存储路径
     
    var volumLab: Double? //显示录音音量
    
    override init() {
         
        //初始化录音器
        let session:AVAudioSession = AVAudioSession.sharedInstance()
         
        //设置录音类型 外放模式
        try! session.setCategory(AVAudioSession.Category.playAndRecord,options: [.defaultToSpeaker,.allowBluetooth])
        //设置支持后台
        try! session.setActive(true)
        //获取Document目录
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0]
        print(docDir)
        //组合录音文件路径
        aacPath = docDir + "/play.aac"
        //初始化字典并添加设置参数
        recorderSeetingsDic =
            [
                AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),//音频格式
                AVNumberOfChannelsKey: 2, //录音的声道数，立体声为双声道
                AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue, //录音质量
                AVEncoderBitRateKey : 320000,
                AVSampleRateKey : 44100.0 //录音器每秒采集的录音样本数
        ]
    }
     
    //按下录音
    @IBAction func downAction(){
        //初始化录音器
        recorder = try! AVAudioRecorder(url: URL(string: aacPath!)!,settings: recorderSeetingsDic!)
        if recorder != nil {
            //开启仪表计数功能
            recorder!.isMeteringEnabled = true
            //准备录音
            recorder!.prepareToRecord()
            //开始录音
            recorder!.record()
            //启动定时器，定时更新录音音量
//            volumeTimer = Timer.scheduledTimer(timeInterval: 3, target: self,
//                                selector: #selector(RTMAudioRecord.levelTimer),
//                                userInfo: nil, repeats: true)
            recorder!.updateMeters()
        }
        
    }
     
    //松开按钮，结束录音
    @IBAction func upAction() {
        //停止录音
        recorder?.pause()
        //录音器释放
//        recorder = nil
        //暂停定时器
//        volumeTimer.invalidate()
//        volumeTimer = nil
        volumLab = 0
    }
     
    //播放录制的声音
    @IBAction func playAction(_ url: URL){
        //播放
        player = try! AVAudioPlayer(contentsOf: url)
        if player == nil {
            print("播放失败")
        } else {
            player?.play()
        }
    }
     
    //定时检测录音音量
    @objc func levelTimer(){
        recorder!.updateMeters() // 刷新音量数据
        let averageV:Float = recorder!.averagePower(forChannel: 0) //获取音量的平均值
        let maxV:Float = recorder!.peakPower(forChannel: 0) //获取音量最大值
        let lowPassResult:Double = pow(Double(10), Double(0.05*maxV))
    }
     
}
