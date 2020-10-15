//
//  DebugMenuViewController.swift
//  GoLog
//
//  Created by NamDV on 8/25/20.
//  Copyright © 2020 ER. All rights reserved.
//

import Foundation
import UIKit

final class DebugMenuViewController: UIViewController {
    
    private (set) var debugMenuTableRows = [DebugMenuRow]()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDataSource()
    }
    
    func setupViews() {
        navigationItem.title = "~ Debug Menu ~"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupDataSource() {
        debugMenuTableRows.append(DebugMenuRow(id: .appInfo, title: "App info"))
        debugMenuTableRows.append(DebugMenuRow(id: .appLog,title: "Log"))
        debugMenuTableRows.append(DebugMenuRow(id: .updateUserDefault,title: "Update UserDefault"))
        debugMenuTableRows.append(DebugMenuRow(id: .resetUserDefault, title: "Reset UserDefault"))
        debugMenuTableRows += XDebug.Configuration.debugMenuTableRows
        tableView.reloadData()
    }
    
}

// MARK: Cell type
extension DebugMenuViewController {
    func value1Cell(withText text: String?, detailText: String?) -> UITableViewCell {
        let cell = UITableViewCell(
            style: .value1,
            reuseIdentifier: "")
        cell.selectionStyle = .none
        cell.textLabel?.text = text
        cell.textLabel?.numberOfLines = 1
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.5
        cell.detailTextLabel?.text = detailText
        cell.detailTextLabel?.numberOfLines = 3
        cell.detailTextLabel?.minimumScaleFactor = 0.5
        cell.detailTextLabel?.lineBreakMode = .byCharWrapping
        return cell
    }
    
    func titleCell(withText text: String?, detailText: String?) -> UITableViewCell {
        let cell = UITableViewCell(
            style: .value1,
            reuseIdentifier: "")
        cell.textLabel?.text = text
        cell.textLabel?.numberOfLines = 1
        cell.textLabel?.minimumScaleFactor = 0.5
        cell.textLabel?.lineBreakMode = .byCharWrapping
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.darkGray
        return cell
    }
    
    func switchCell(withText text: String?, isOn: Bool, target: Any, selfAction: Selector) -> UITableViewCell {
        let cell = UITableViewCell(
            style: .value1,
            reuseIdentifier: "")
        
        let swt = UISwitch(frame: CGRect(x: UIScreen.main.bounds.width - 60, y: 9, width: 51, height: 31))
        swt.isOn = isOn
        swt.addTarget(target, action: selfAction, for: .valueChanged)
        cell.contentView.addSubview(swt)
        cell.textLabel?.text = text
        
        return cell
    }
}
