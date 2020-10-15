//
//  UIViewController+Extension.swift
//  GoLog
//
//  Created by Dung Tran Van on 10/15/20.
//  Copyright © 2020 GoLog. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    static func initFromNib(bundle: Bundle?) -> Self {
        
        func instanceFromNib<T: UIViewController>() -> T {
            return T(nibName: String(describing: self), bundle: bundle)
        }
        return instanceFromNib()
    }
}
