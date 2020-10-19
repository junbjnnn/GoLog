//
//  DebugMenuViewController+Delegate.swift
//  GoLog
//
//  Created by NamDV on 9/7/20.
//  Copyright © 2020 ER. All rights reserved.
//

import Foundation
import UIKit

public protocol AddOnDebugMenuDelegate: AnyObject {
    func didSelectMenu(at id: GoLog.MenuId, on viewController: UIViewController)
    func switchOptionChanged(at id: GoLog.MenuId, isOn: Bool)
}

// MARK: UITableViewDelegate
extension DebugMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = debugMenus[indexPath.row]
        switch menuItem.menuId {
        case .appInfo:
            push(DebugInfoViewController())
        case .appLog:
            let bundle = Bundle(for: self.classForCoder)
            let vc = DebugLogViewController.initFromNib(bundle: bundle)
            push(vc)
        case .userDefaults:
            push(DebugUserDefaultViewController())
        case .resetUserDefaults:
            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                defaults.removeObject(forKey: key)
            }
        default:
            if !menuItem.style.isSwitchStyle {
                GoLog.debugMenuDelegate?.didSelectMenu(at: menuItem.menuId, on: self)
            }
        }
    }
    
    func push(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
