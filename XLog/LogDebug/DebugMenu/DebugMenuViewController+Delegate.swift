//
//  DebugMenuViewController+Delegate.swift
//  XLog
//
//  Created by NamDV on 9/7/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import UIKit

// MARK: UITableViewDelegate
extension DebugMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch DebugMenuTableRow(rawValue: indexPath.row) {
        case .appInfo:
            push(DebugInfoViewController())
        case .log:
            push(DebugLogViewController())
        case .updateUserDefault:
            push(DebugUserDefaultViewController())
        case .resetUserDefault:
            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                defaults.removeObject(forKey: key)
            }
        default:
            break
        }
    }
    
    func push(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
