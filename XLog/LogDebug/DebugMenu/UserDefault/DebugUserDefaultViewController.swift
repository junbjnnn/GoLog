//
//  DebugUserDefaultViewController.swift
//  XLog
//
//  Created by NamDV on 9/30/20.
//  Copyright © 2020 ER. All rights reserved.
//

import Foundation
import UIKit

enum DebugUserDefaultTableRow: Int {
    case loginToken
    case count
}

struct DebugUserDefaultModel {
    // var loginToken = "LoginToken"
}

final class DebugUserDefaultViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    private var userDefaultInfo = DebugUserDefaultModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: "textFieldCell")
    }
    
    func setupNavigation() {
        navigationItem.title = "~ UserDefault ~"
        
        let saveButton = UIBarButtonItem(
            title: "💾",
            style: .plain,
            target: self,
            action: #selector(updateUserDefault(_:)))
        navigationItem.rightBarButtonItems = [saveButton]
    }
    
    @objc
    func updateUserDefault(_ sender: Any?) {
        // TODO: Update userdefault

        let alertController = UIAlertController(title: "Success",
                                                message: "Saved new value userdefault!",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource
extension DebugUserDefaultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DebugUserDefaultTableRow.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as? TextFieldCell {
            cell.selectionStyle = .none
            cell.dataTextField.tag = indexPath.section
            cell.dataTextField.delegate = self
            switch DebugUserDefaultTableRow(rawValue: indexPath.section) {
            case .loginToken:
                cell.dataTextField.text = "XXX"
            default:
                break
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch DebugUserDefaultTableRow(rawValue: section) {
        case .loginToken:
            return "Login token"
        default:
            return "?"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }
    
    @objc
    func valueChanged(_ textField: UITextField) {
        switch DebugUserDefaultTableRow(rawValue: textField.tag) {
        case .loginToken:
            break
        default:
            break
        }
    }
    
}

class TextFieldCell: UITableViewCell {
    
    let dataTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initConstraints() {
        addSubview(dataTextField)
        
        NSLayoutConstraint.activate([
            dataTextField.heightAnchor.constraint(equalToConstant: 40),
            dataTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dataTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            dataTextField.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            dataTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
}
