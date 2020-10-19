//
//  ViewController.swift
//  GoLog
//
//  Created by NamDV on 10/13/20.
//  Copyright © 2020 ER. All rights reserved.
//

import UIKit
import GoLog

// GoLog - Config more category
extension GoLog.Category {
    static let auth = GoLog.Category("AUTH")
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Log basic app info
        GoLog.logAppInfo()
        
        // Log syntax
        testLog()
    }
    
    
    func testLog() {
        GoLog.log("1/ Default category = .app, type = .default - Message")
        GoLog.log(type: .default, "2/ Default category = .app, - Message")
        GoLog.log(category: .app, type: .default, "3/ Message")
        
        GoLog.log(category: .auth, type: .debug, "4/ Without options")
        GoLog.log(category: .api, type: .info, "5/ Without options", options: [])
        GoLog.log(category: .auth, type: .fault, "6/ With function", options: [.function])
        GoLog.log(category: .api, type: .error, "7/ With fileAndLine", options: [.fileAndLine])
        GoLog.log(category: .app, type: .default, "8/ With all options", options: [.all])
    }
}
