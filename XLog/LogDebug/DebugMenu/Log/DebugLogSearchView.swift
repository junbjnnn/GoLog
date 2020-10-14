//
//  DebugLogSearchView.swift
//  XLog
//
//  Created by NamDV on 10/9/20.
//  Copyright © 2020 ER. All rights reserved.
//

import UIKit

protocol DebugLogSearchViewDelegate: AnyObject {
    func didDeleteTextField(_ view: BaseView)
}

class DebugLogSearchView: BaseView {
    
    weak var delegate: DebugLogSearchViewDelegate?
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var deleteButton: UIButton!
    
    var isHiddenDeleteBtn = false {
        didSet {
            deleteButton.isHidden = isHiddenDeleteBtn
        }
    }
    
    func getTextField() -> UITextField {
        return searchTextField
    }
    
    @IBAction private func onDeleteTextField(_ sender: Any) {
        delegate?.didDeleteTextField(self)
    }
}
