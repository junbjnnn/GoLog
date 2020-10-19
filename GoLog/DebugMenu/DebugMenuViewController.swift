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
    
    private (set) var debugMenus = [GoLog.AddOnDebugMenu]()
    
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
        tableView.register(DebugMenuDefaultCell.self, forCellReuseIdentifier: DebugMenuDefaultCell.cellId)
        tableView.register(DebugMenuSwitchCell.self, forCellReuseIdentifier: DebugMenuSwitchCell.cellId)
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
        debugMenus.removeAll()
        debugMenus.append(contentsOf: GoLog.buildDefaultMenus)
        debugMenus.append(contentsOf: GoLog.configuration.addOnDebugMenu)
        tableView.reloadData()
    }
}

extension DebugMenuViewController: DebugMenuSwitchDelegate {
    func switchOptionChanged(at menuId: GoLog.MenuId, isOn: Bool) {
        GoLog.debugMenuDelegate?.switchOptionChanged(at: menuId, isOn: isOn)
    }
}

class DebugMenuDefaultCell: UITableViewCell {
    
    static let cellId = "DebugMenuDefaultCellId"
    
    var data: GoLog.AddOnDebugMenu! {
        didSet {
            textLabel?.text = data.title
            detailTextLabel?.text = data.style.detailText ?? ""
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        textLabel?.numberOfLines = 1
        textLabel?.adjustsFontSizeToFitWidth = true
        textLabel?.minimumScaleFactor = 0.5
        detailTextLabel?.numberOfLines = 3
        detailTextLabel?.minimumScaleFactor = 0.5
        detailTextLabel?.lineBreakMode = .byCharWrapping
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

protocol DebugMenuSwitchDelegate {
    func switchOptionChanged(at menuId: GoLog.MenuId, isOn: Bool)
}

class DebugMenuSwitchCell: UITableViewCell {
    
    static let cellId = "DebugMenuSwitchCellId"
    var delegate: DebugMenuSwitchDelegate?
    var data: GoLog.AddOnDebugMenu! {
        didSet {
            textLabel?.text = data.title
            switch data.style {
            case .switchRow(let isOn):
                switchOption.isOn = isOn
            default:
                break
            }
        }
    }

    var switchOption: UISwitch = {
        let switchOpt = UISwitch(frame: CGRect(x: UIScreen.main.bounds.width - 60, y: 9, width: 51, height: 31))
        return switchOpt
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        switchOption.addTarget(self, action: #selector(switchOptionChanged), for: .valueChanged)
        contentView.addSubview(switchOption)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func switchOptionChanged() {
        delegate?.switchOptionChanged(at: data.menuId, isOn: switchOption.isOn)
    }
}
