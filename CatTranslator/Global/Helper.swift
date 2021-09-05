//
//  Helper.swift
//  CatTranslator
//
//  Created by GC on 2021/9/2.
//

import UIKit

func getRootViewController() -> UIViewController? {
    if let window = UIApplication.shared.delegate?.window {
        if let rootViewController = window?.rootViewController {
            return rootViewController
        }
    }
    return nil
}
