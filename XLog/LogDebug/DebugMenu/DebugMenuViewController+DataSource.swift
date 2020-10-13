//
//  DebugMenuViewController+DataSource.swift
//  XLog
//
//  Created by NamDV on 9/7/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import UIKit

enum DebugMenuTableRow: Int {
    case appInfo
    case log
    case updateUserDefault
    case resetUserDefault
    // TODO: Change to struct => extend this cases
    case restrictControl
    case logout
    case count
}

// MARK: UITableViewDataSource
extension DebugMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DebugMenuTableRow.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch DebugMenuTableRow(rawValue: indexPath.row) {
        case .appInfo:
            return value1Cell(withText: "App info", detailText: ">")
        case .log:
            return value1Cell(withText: "Log", detailText: ">")
        case .logout:
            return value1Cell(withText: "Logout", detailText: "isLogin = ")
        case .restrictControl:
            return switchCell(withText: "Disable Restrict", isOn:false, selfAction: #selector(self.restrictControl))
        case .updateUserDefault:
            return value1Cell(withText: "Update UserDefault", detailText: ">")
        case .resetUserDefault:
            return value1Cell(withText: "Reset UserDefault", detailText: "")
        default:
            break
        }
        return UITableViewCell()
    }
    
    @objc
    func restrictControl(_ swt: UISwitch) {
        //
    }
    
}
