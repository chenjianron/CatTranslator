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
        
//        if !UserDefaults.standard.bool(forKey: "FirstLaunch") {
//            viewController = PreviewPageVC()
//            UserDefaults.standard.setValue(true, forKey: "FirstLaunch")
//        } else {
//            viewController = MainVC()
//        }
        viewController = PreviewPageVC()
        let navigationController = SSNavigationController(rootViewController: viewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

