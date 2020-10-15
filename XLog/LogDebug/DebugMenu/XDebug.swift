//
//  XDebug.swift
//  XLog
//
//  Created by NamDV on 10/14/20.
//  Copyright © 2020 ER. All rights reserved.
//

import Foundation

public final class XDebug {
    struct Configuration {
        public static var debugMenuEnable = false {
            didSet {
                if debugMenuEnable {
                    DebugMenu.shared.addDebugMenu()
                } else {
                    DebugMenu.shared.removeDebugMenu()
                }
            }
        }
        public static var debugMenuTableRows = [DebugMenuRow]()
        public static var debugMenuDelegate: DebugMenuDelegate?
        public static var debugAppInfoText = ""
    }
}

public struct DebugMenuRow {
    enum RowType {
        case switchRow(isOn: Bool, target: Any, selfAction: Selector)
        case defaultRow(detailText: String)
    }
    
    struct RowID: Equatable {
        private var rawValue: String
        
        public static let appInfo = RowID("appInfo")
        public static let appLog = RowID("appLog")
        public static let updateUserDefault = RowID("updateUserDefault")
        public static let resetUserDefault = RowID("resetUserDefault")
        
        init(_ rawValue: String) {
            self.rawValue = rawValue
        }
        
        static func == (lhs: RowID, rhs: RowID) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
    }
    
    var id: RowID
    var title: String
    var type: RowType = .defaultRow(detailText: ">")
}
