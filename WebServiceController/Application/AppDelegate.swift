//
//  AppDelegate.swift
//  WebServiceController
//
//  Created by Sean on 5/22/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let postsViewController = PostsViewController()
        let navigationController = UINavigationController(rootViewController: postsViewController)
        navigationController.navigationBar.isTranslucent = false
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()

        return true
    }
}

