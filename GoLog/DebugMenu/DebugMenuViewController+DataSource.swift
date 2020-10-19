//
//  DebugMenuViewController+DataSource.swift
//  GoLog
//
//  Created by NamDV on 9/7/20.
//  Copyright © 2020 ER. All rights reserved.
//

import Foundation
import UIKit

// MARK: UITableViewDataSource
extension DebugMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return debugMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuItem = debugMenus[indexPath.row]
        switch menuItem.style {
        case .defaultRow:
            if let cell = tableView.dequeueReusableCell(withIdentifier: DebugMenuDefaultCell.cellId, for: indexPath) as? DebugMenuDefaultCell {
                cell.data = menuItem
                return cell
            }
        case .switchRow:
            if let cell = tableView.dequeueReusableCell(withIdentifier: DebugMenuSwitchCell.cellId, for: indexPath) as? DebugMenuSwitchCell {
                cell.data = menuItem
                cell.delegate = self
                return cell
            }
        }
        return UITableViewCell()
    }
}
