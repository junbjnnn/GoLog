//
//  ViewController.swift
//  XLog
//
//  Created by NamDV on 10/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import SwiftLog

// XLog - Config more category
extension Logger.Category {
    static let auth = Logger.Category("AUTH")
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        testLog()
        DebugMenu.shared.enable = true
        LoggerHelper.logAppInfo()
    }
    
    
    func testLog() {
        Logger.log("1/ Default category = .app, type = .default - Message")
        Logger.log(type: .default, "2/ Default category = .app, - Message")
        Logger.log(category: .app, type: .default, "3/ Message")
        
        Logger.log(category: .auth, type: .debug, "4/ Without options")
        Logger.log(category: .api, type: .info, "5/ Without options", options: [])
        Logger.log(category: .auth, type: .fault, "6/ With function", options: [.function])
        Logger.log(category: .api, type: .error, "7/ With fileAndLine", options: [.fileAndLine])
        Logger.log(category: .app, type: .default, "8/ With all options", options: [.all])
    }

}

