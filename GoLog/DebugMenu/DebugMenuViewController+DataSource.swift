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
        return debugMenuTableRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = debugMenuTableRows[indexPath.row]
        
        switch row.type {
        case .defaultRow(let detailText):
            return value1Cell(withText: row.title, detailText: detailText)
        case .switchRow(let isOn, let target, let selfAction):
            return switchCell(withText: row.title, isOn:isOn, target: target, selfAction: selfAction)
        }
    }
    
    
}
