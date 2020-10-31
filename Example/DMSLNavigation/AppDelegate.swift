//
//  AppDelegate.swift
//  DMSLNavigation
//
//  Created by dmsl1805 on 10/31/2020.
//  Copyright (c) 2020 dmsl1805. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController.initializeRoot()
        window?.makeKeyAndVisible()
        return true
    }
}

