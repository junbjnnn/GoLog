//
//  AppDelegate.swift
//  GoLog
//
//  Created by NamDV on 10/13/20.
//  Copyright © 2020 GoLog. All rights reserved.
//

import UIKit
import GoLog

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        // Override point for customization after application launch.
        setupLog()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func setupLog() {
        UserDefaults.standard.set(999, forKey: "GoLog_1")
        UserDefaults.standard.set("hello word", forKey: "GoLog_2")
        GoLog.setup(with: .init(userDefaultsKeys: [.init(key: "GoLog_1"), .init(key: "GoLog_2")]))
    }
}

