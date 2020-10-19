//
//  DebugUserDefaultViewController.swift
//  GoLog
//
//  Created by NamDV on 9/30/20.
//  Copyright © 2020 ER. All rights reserved.
//

import Foundation
import UIKit

final class DebugUserDefaultViewController: UIViewController {
    
    private let cellKey = "cell_default_key"
    
    private lazy var userDefaultsKeys: [GoLog.LocalUserDefaultsKey] = {
        if GoLog.configuration == nil {
            return []
        }
        return GoLog.configuration.userDefaultsKeys
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "~ UserDefault ~"
        setupViews()
        tableView.register(UserDefaultTableViewCell.self, forCellReuseIdentifier: cellKey)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: UITableViewDataSource
extension DebugUserDefaultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDefaultsKeys.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellKey, for: indexPath) as? UserDefaultTableViewCell {
            cell.item = userDefaultsKeys[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = userDefaultsKeys[indexPath.row]
//        showAlertEditUserDefaults(for: item)
    }
    
    private func showAlertEditUserDefaults(for item: GoLog.LocalUserDefaultsKey) {
        let ac = UIAlertController(title: "Update key: \(item.key)", message: nil, preferredStyle: .alert)
        ac.addTextField { (textfield) in
            if let value = UserDefaults.standard.object(forKey: item.key) {
                textfield.text = "\(value)"
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Save", style: .default) { [unowned ac] _ in
            if let tf = ac.textFields?.first {
                print("Textfield: \(tf.text ?? "")")
            }
        }
        ac.addAction(cancelAction)
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
}

extension UserDefaults {
    func parse(key: String) -> String {
        guard let value = UserDefaults.standard.object(forKey: key) else { return "" }
        if type(of: value) == Bool.self {
        }
        if let valueBool = value as? Bool {
            return valueBool ? "true" : "false"
        }
        return "\(value)"
    }
}

class UserDefaultTableViewCell: UITableViewCell {
    
    var item: GoLog.LocalUserDefaultsKey! {
        didSet {
            titleLabel.text = "key: \(item.key)"
            let value = UserDefaults.standard.parse(key: item.key)
            valueLabel.text = "value: \(value)"
        }
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(lineView)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineView.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 20),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        valueLabel.text = ""
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
