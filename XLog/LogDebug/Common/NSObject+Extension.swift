//
//  NSObject+Extension.swift
//  XLog
//
//  Created by NamDV on 10/14/20.
//  Copyright © 2020 ER. All rights reserved.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}
