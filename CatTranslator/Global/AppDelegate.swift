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
//        let navigationController = SSNavigationController(rootViewController: viewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }

}

