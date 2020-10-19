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
        configGoLog()
        let vc = ViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        GoLog.showDebugMenu = true
        return true
    }
    
    private func configGoLog() {
        //save demo key
        UserDefaults.standard.set(999, forKey: "ud_key_1")
        UserDefaults.standard.set("hello word", forKey: "ud_key_2")

        let menu = [
            GoLog.AddOnDebugMenu(menuId: .custom(key: "test1"), title: "Test 1"),
            GoLog.AddOnDebugMenu(menuId: .custom(key: "test2"), title: "Test 2"),
            GoLog.AddOnDebugMenu(menuId: .custom(key: "test3"), title: "Test 3", style: .switchRow(isOn: false))
        ]
        let userDefaults = [GoLog.LocalUserDefaultsKey(key: "ud_key_1"), GoLog.LocalUserDefaultsKey(key: "ud_key_2")]
        let config = GoLog.Configuration(
            logToFile: true,
            debugAppInfoText: "Show more app info",
            addOnDebugMenu: menu,
            userDefaultsKeys: userDefaults
        )
        GoLog.setup(with: config, debugMenuDelegate: self)
    }
}

extension AppDelegate: AddOnDebugMenuDelegate {
    func didSelectMenu(at id: GoLog.MenuId, on viewController: UIViewController) {
        switch id {
        case .custom(let key):
            if key == "test1" {
                viewController.navigationController?.pushViewController(DebugInfoViewController(), animated: true)
            } else if key == "test2" {
                let alertVC = UIAlertController(title: "Title", message: "Message!", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                viewController.present(alertVC, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    func switchOptionChanged(at id: GoLog.MenuId, isOn: Bool) {
        print("switch option at \(id) -- \(isOn)")
    }
    
}
