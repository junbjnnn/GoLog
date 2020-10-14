//
//  Array+Extension.swift
//  XLog
//
//  Created by NamDV on 10/13/20.
//  Copyright © 2020 ER. All rights reserved.
//

import Foundation

extension Array {
    
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
    
    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= 0, index < endIndex else {
            return defaultValue()
        }

        return self[index]
    }
    
}
