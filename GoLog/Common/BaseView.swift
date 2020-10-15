//
//  BaseView.swift
//  GoLog
//
//  Created by NamDV on 8/21/20.
//  Copyright © 2020 ER. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setupLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }

    private func commonInit() {
        let bundle = Bundle(for: self.classForCoder)
        guard bundle.path(forResource: className, ofType: "nib") != nil else {
            // file not exists
            return
        }
        guard let content = bundle.loadNibNamed(className, owner: self, options: nil)?.first as? UIView else {
            return
        }

        addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
                                                                   options: .directionLeadingToTrailing,
                                                                   metrics: nil,
                                                                   views: ["view": content]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
                                                                   options: .directionLeadingToTrailing,
                                                                   metrics: nil,
                                                                   views: ["view": content]))
    }

    func setupLayout() {}
    
    func updateLayout() {}
    
    deinit {
        GoLog.log(type: .debug, String(describing: self), options: [.function])
    }
}
