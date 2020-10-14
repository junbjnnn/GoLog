//
//  ViewController.swift
//  XLog
//
//  Created by NamDV on 10/13/20.
//  Copyright © 2020 ER. All rights reserved.
//

import UIKit
import SwiftLog

// XLog - Config more category
extension XLog.Category {
    static let auth = XLog.Category("AUTH")
}

// XDebug - Config more row
extension DebugMenuRow.RowID {
    static let test1 = DebugMenuRow.RowID("test1")
    static let test2 = DebugMenuRow.RowID("test2")
    static let test3 = DebugMenuRow.RowID("test3")
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        XLog.logAppInfo()
        testLog()
        
        XDebug.Configuration.debugMenuEnable = true
        XDebug.Configuration.debugMenuDelegate = self
        XDebug.Configuration.debugMenuTableRows.append(DebugMenuRow(id: .test1,
                                                                    title: "Test 1"))
        XDebug.Configuration.debugMenuTableRows.append(DebugMenuRow(id: .test2 ,
                                                                    title: "Test 2",
                                                                    type: .defaultRow(detailText: "Detail")))
        XDebug.Configuration.debugMenuTableRows.append(DebugMenuRow(id: .test3,
                                                                    title: "Test 3",
                                                                    type: .switchRow(isOn: false, target: self, selfAction: #selector(self.switchAction))))
    }
    
    
    func testLog() {
        XLog.log("1/ Default category = .app, type = .default - Message")
        XLog.log(type: .default, "2/ Default category = .app, - Message")
        XLog.log(category: .app, type: .default, "3/ Message")
        
        XLog.log(category: .auth, type: .debug, "4/ Without options")
        XLog.log(category: .api, type: .info, "5/ Without options", options: [])
        XLog.log(category: .auth, type: .fault, "6/ With function", options: [.function])
        XLog.log(category: .api, type: .error, "7/ With fileAndLine", options: [.fileAndLine])
        XLog.log(category: .app, type: .default, "8/ With all options", options: [.all])
    }
    
    @objc
    func switchAction(_ swt: UISwitch) {
        print("Switch isOn - \(swt.isOn)")
    }
    
}

extension ViewController: DebugMenuViewControllerDelegate {
    
    func didSelectRow(_ id: DebugMenuRow.RowID, on vc: UIViewController) {
        switch id {
        case .test1:
            vc.navigationController?.pushViewController(DebugInfoViewController(), animated: true)
        case .test2:
            let alertController = UIAlertController(title: "Title",
                                                    message: "Message!",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            vc.present(alertController, animated: true, completion: nil)
        default:
            break
        }
    }
    
}
