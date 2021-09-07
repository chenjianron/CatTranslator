//
//  UIViewController.swift
//  IconChanger
//
//  Created by  HavinZhu on 2020/7/14.
//  Copyright © 2020 HavinZhu. All rights reserved.
//
import SnapKit
import Toolkit

extension UIViewController {

    var safeTop: CGFloat {
        get {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide.layoutFrame.minY
            } else {
                return topLayoutGuide.length
            }
        }
    }
    
    var safeBottom: CGFloat {
        get {
            if #available(iOS 11.0, *) {
                return view.height - safeTop - view.safeAreaLayoutGuide.layoutFrame.height
            } else {
                return bottomLayoutGuide.length
            }
        }
    }
    
    var safeAreaTop: ConstraintItem {
        get {
            if #available(iOS 11.0, *) {
                return self.view.safeAreaLayoutGuide.snp.top
            } else {
                return self.topLayoutGuide.snp.top
            }
        }
    }
    
    var safeAreaBottom: ConstraintItem {
        get {
            if #available(iOS 11.0, *) {
                return self.view.safeAreaLayoutGuide.snp.bottom
            } else {
                return self.bottomLayoutGuide.snp.bottom
            }
        }
    }
    
    var safeAreaHeight: CGFloat {
        get {
            return self.view.height - safeTop - safeBottom
        }
    }
    
}

extension UIViewController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController.setNavigationBarHidden(false, animated: true)
            if let delegate = navigationController.delegate {
                if delegate.isEqual(self) {
                    navigationController.delegate = nil
                }
            }
        }
    }
    
}
