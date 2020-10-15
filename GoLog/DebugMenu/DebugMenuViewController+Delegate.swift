//
//  DebugMenuViewController+Delegate.swift
//  GoLog
//
//  Created by NamDV on 9/7/20.
//  Copyright © 2020 ER. All rights reserved.
//

import Foundation
import UIKit

public protocol DebugMenuDelegate: AnyObject {
    func didSelectRow(_ id: DebugMenuRow.RowID, on vc: UIViewController)
}

// MARK: UITableViewDelegate
extension DebugMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = debugMenuTableRows[indexPath.row]
        
        switch row.id {
        case .appInfo:
            push(DebugInfoViewController())
        case .appLog:
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
            XDebug.Configuration.debugMenuDelegate?.didSelectRow(row.id, on: self)
            break
        }
    }
    
    func push(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
