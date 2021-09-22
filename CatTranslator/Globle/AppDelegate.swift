//
//  AppDelegate.swift
//  CatTranslator
//
//  Created by GC on 2021/9/2.
//

import Toolkit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var viewController:UIViewController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if !UserDefaults.standard.bool(forKey: "FirstLaunch") {
            viewController = PreviewPageVC()
            UserDefaults.standard.setValue(true, forKey: "FirstLaunch")
            viewController = SSNavigationController(rootViewController: viewController)
        } else {
            let tabbarController = UITabBarController()
            tabbarController.tabBar.barTintColor = UIColor.white
            
            let mainVC = SSNavigationController(rootViewController: MainVC())
            mainVC.tabBarItem.title = __("翻译")
            mainVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: K.Color.ThemeColor], for: .selected)
            mainVC.tabBarItem.image = #imageLiteral(resourceName: "TarBarImage1-Selected")
            mainVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "TarBarImage1")
            tabbarController.addChild(mainVC)
            
            let playCatVC = SSNavigationController(rootViewController: PlayCatVC())
            playCatVC.tabBarItem.title = __("逗猫")
            playCatVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: K.Color.ThemeColor], for: .selected)
            playCatVC.tabBarItem.image = #imageLiteral(resourceName: "TarBarImage2")
            playCatVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "TarBarImage2-Selected")
            tabbarController.addChild(playCatVC)
            viewController = tabbarController
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        Marketing.shared.setup()
        setupNotification(launchOptions: launchOptions)
        AppTracking.shared.requestIDFA()
        
        return true
    }

}

// MARk: -友盟推送
extension AppDelegate {
    
    func setupNotification(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        UIApplication.shared.applicationIconBadgeNumber = 0
   
        let entity = UMessageRegisterEntity()
        entity.types = Int(UMessageAuthorizationOptions.alert.rawValue)
               | Int(UMessageAuthorizationOptions.sound.rawValue)
               | Int(UMessageAuthorizationOptions.badge.rawValue)
           
        UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entity, completionHandler: { (granted, error) in
            LLog("推送: ", granted)
            if let error = error {
                LLog(error.localizedDescription)
           }
        })
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       UMessage.registerDeviceToken(deviceToken)
       
       #if DEBUG
       print(#function, "deviceToken", NotificationHandler.deviceToken(deviceToken) ?? "")
       #endif
   }
   
   func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        LLog(error)
    }
   
   func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NotificationHandler.process(userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        NotificationHandler.process(userInfo: userInfo)
    }
}
