//
//  Constant.swift
//  SplitScreen
//
//  Created by  HavinZhu on 2020/7/27.
//  Copyright © 2020 HavinZhu. All rights reserved.
//
import Toolkit

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height
let AppName = __("CatTranslator")
let Quotations = [
    __("来啊！互相伤害啊！！"),__("牛奶，我只喝最好的(๑>؂<๑）"),__("小鱼干yyds！！"),__("干嘛拿着手机对着我"),__("我们一起喵喵喵！一起喵喵喵喵喵～"),__("给我买个毛线球吧～"),__("又是被迫营业的一天啊～"),__("我是谁，我在哪？？"),__("铲屎官，你今天有点怪，怪可爱的～"),__("我是这个家最好看的，不接受反驳！"),__("我掉的不是毛，是魅力！！"),__("我就是这个家的主人！"),__("请给我准备一车的小鱼干儿"),__("守护全世界最好的铲屎官"),__("说点啥好捏～～"),__("来，我教你喵星语！"),__("坐等开饭！!"),__("嗨 今天玩什么～"),__("最近脖子有点痒，需要挠挠"),__("吃得饱饱的 安全～～"),__("那个胖家伙是谁 危险危险危险！！"),__("今天心情不错，陪你玩一会吧"),__("今天也是需要干饭的一天"),__("我有洁癖，猫砂盆要随时保持干净哦～"),__("干嘛？有好东西吃吗？没有？那你叫我干嘛？"),__("我讨厌打针吃药"),__("你为啥总对我发出“喵喵”这个声音？"),__("小玩具永远不嫌多"),__("你不说爱我我就，喵喵喵～"),__("你只能是我的铲屎官哦！！"),__("你的板砖怎么会说话！"),__("我要看动画片～～"),__("困困了，该睡觉啦～"),__("哦耶，元气满满～"),__("不要拿其他吃的糊弄我，我要的是小鱼干！！"),__("听到你找我啦！但是我不想动！！"),__("我想打个盹，安静点哦"),__("那个东西看起来好好玩"),__("这鱼塘我承包了"),__("不要不开心 我来保护你"),__("我是小猫咪 你的小调皮～"),__("我对你很感兴趣哦～"),__("^_^睡到自然醒 然后接着睡^_^"),__("别妄想知道我在嘀咕什么～"),__("还记得是什么时候把我领回家的嘛～"),__("我是肥宅快乐喵"),__("请不要每天窥探我的美貌～"),__("干嘛，叫我去抓老鼠吗？"),__("哈哈哈哈哈哈哈哈～～"),__("你可不能背着我跟其他猫猫玩！！")
]

struct K {
    struct IDs {
        
        static let AppID = "1571453641"
        //        static let GroupName = "group.com.softin.ScreenRecorder3"
        static let UMengKey = "60c069791568bb08a5be664b"
        
        static let SSID = "a4nrtddq1cw64lr8"
        static let SSKey = "obcqxzk6dtsardn4"
        static let SSRG = "oss-cn-hongkong"
        
        static let Secret = "ImageSearch/\(Util.appVersion())/meto.otf"
        static let adMobAppId = "ca-app-pub-1526777558889812~7180568285"
        
        //        #if DEBUG
        //        static let BannerUnitID = "ca-app-pub-1526777558889812/1928241607"
        //        static let InterstitialUnitID = "ca-app-pub-1526777558889812/3463016257"
        //        static let InterstitialTransferUnitID = "ca-app-pub-1526777558889812/7318786197"
        //        static let RewardUnitID = "ca-app-pub-3940256099942544/1712485313"
        //        #else
        //        static let BannerUnitID = "ca-app-pub-1526777558889812/1928241607"
        //        static let InterstitialUnitID = "ca-app-pub-1526777558889812/3463016257"
        //        static let InterstitialSaveUnitID = "ca-app-pub-1526777558889812/2930324944"
        //        static let InterstitialTransferUnitID = "ca-app-pub-1526777558889812/7318786197"
        //        static let RewardUnitID = "ca-app-pub-1526777558889812/5423421726"
        //        #endif
        
        //        #if DEBUG
        static let BannerUnitID = "ca-app-pub-3940256099942544/2934735716"
        static let InterstitialUnitID = "ca-app-pub-3940256099942544/4411468910"
        static let InterstitialTransferUnitID = "ca-app-pub-3940256099942544/4411468910"
        static let RewardUnitID = "ca-app-pub-3940256099942544/1712485313"
        //        #else
        //           static let BannerUnitID = "ca-app-pub-1526777558889812/7898692549"
        //           static let InterstitialUnitID = "ca-app-pub-1526777558889812/4626549998"
        //           static let InterstitialSaveUnitID = "ca-app-pub-1526777558889812/2930324944"
        //           static let InterstitialTransferUnitID = "ca-app-pub-1526777558889812/5423421726"
        //    //        static let RewardUnitID = "ca-app-pub-1526777558889812/5423421726"
        //        #endif
        
    }
    
    struct Share {
        static let normalContent = String(format: "https://itunes.apple.com/cn/app/id%@?mt=8&l=%@", K.IDs.AppID, Util.languageCode())
        static let Email = "Image_Search_feedback@outlook.com"
    }
    
    struct Website {
        static let PrivacyPolicy = "https://websprints.github.io/PasteKeyboard/PrivacyPolicy.html"
        static let UserAgreement = "https://websprints.github.io/PasteKeyboard/UserAgreement.html"
    }
    
    struct Color {
        static let ThemeColor = UIColor(hex: 0xFF6D92)
        static let AuxiliaryColor = UIColor(hex: 0x1BBFFE)
    }
    
    struct ParamName {
        
        static let IDFA_Time = "S.Ad.广告跟踪二次弹窗时间"
        static let IDFA_Count = "S.Ad.广告跟踪二次弹窗次数"
        
        static let HomePageBanner = "S.Ad.首页" // 首页广告栏控制开关
        static let SettingPageBanner = "S.Ad.设置页" // 设置页广告栏控制开关
        static let SearchRecordBanner = "S.Ad.搜索记录页" // 搜索记录页广告栏控制开关
        static let WebBanner = "S.Ad.浏览器页" //浏览器网页面广告栏控制开关
        
        static let LaunchInterstitial = "p1-1" // 每N次启动弹出插屏广告
        static let SwitchInterstitial = "p1-2" // 每N次进入前台弹出插屏广告
        static let PickerInterstitial = "p1-3"
        static let CameraInterstitial = "p1-4"
        static let URLInterstitial = "p1-5"
        static let KeywordInterstitial = "p1-7"
        static let SaveImageInterstitial = "p1-8"
        static let DeleteImageInterstitial = "p1-9"
        static let SearchImageInterstitial = "p1-10"
        
        static let ShareRT = "p2-1" //分享后返回设置页弹窗
        static let ImagePickerRT = "p2-2" //保存后弹窗
        static let LauchAPPRT = "p2-3" //启动/返回应用弹窗
        
        static let pushAlertDays = "p3-1" // 用户未允许通知提醒，每隔N天后弹出通知提醒
        static let RTTime = "p3-0"  //评论间隔小时
        //        static let saveRT = "p3-2" //保存后弹窗
        static let EnterRT = "p3-3" //启动/返回应用弹窗
        
    }
}

struct NotificationName {
    static let RefreshBookmark = NSNotification.Name("RefreshBookmark")
    static let UserAgentDidChange = NSNotification.Name("UserAgentDidChange")
}
