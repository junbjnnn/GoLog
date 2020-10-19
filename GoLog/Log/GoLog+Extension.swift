//
//  GoLog+Extension.swift
//  GoLog
//
//  Created by Dung Tran Van on 10/18/20.
//  Copyright © 2020 GoLog. All rights reserved.
//

import Foundation
import SwiftLog
import os.log

extension GoLog {
    static var buildDefaultMenus: [GoLog.AddOnDebugMenu] = {
        return [
            GoLog.AddOnDebugMenu(menuId: .appInfo, title: "App Info"),
            GoLog.AddOnDebugMenu(menuId: .appLog, title: "Log"),
            GoLog.AddOnDebugMenu(menuId: .userDefaults, title: "UserDefaults"),
            GoLog.AddOnDebugMenu(menuId: .resetUserDefaults, title: "Reset UserDefaults")
        ]
    }()
    
    public struct LocalUserDefaultsKey {
        var key: String
        var description: String?
        
        public init(key: String) {
            self.key = key
        }
    }
    
    public struct AddOnDebugMenu {
        var menuId: MenuId
        var title: String
        var style: MenuStyle = .defaultRow(detailText: ">")
        
        public init(menuId: MenuId, title: String) {
            self.menuId = menuId
            self.title = title
        }
        
        public init(menuId: MenuId, title: String, style: MenuStyle) {
            self.menuId = menuId
            self.title = title
            self.style = style
        }
        
        public enum MenuStyle {
            case switchRow(isOn: Bool)
            case defaultRow(detailText: String)
        }
    }
    
    public enum MenuId {
        case appInfo
        case appLog
        case userDefaults
        case resetUserDefaults
        case custom(key: String)
    }
}

extension GoLog.AddOnDebugMenu.MenuStyle {
    var detailText: String? {
        switch self {
        case .defaultRow(let detailText):
            return detailText
        default:
            return nil
        }
    }
    
    var isSwitchStyle: Bool {
        switch self {
        case .switchRow:
            return true
        default:
            return false
        }
    }
}

public extension GoLog {
    struct Category: Equatable {
        private var rawValue: String
        
        public static let app = Category("APP")
        public static let api = Category("API")
        public static let layout = Category("LAYOUT")
        
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static func == (lhs: Category, rhs: Category) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
    }
    
    enum Option: CaseIterable {
        case fileAndLine
        case function
        case all
    }
}

public extension GoLog.Category {
    var osLog: OSLog {
        let defaultSubsystem = Bundle.main.bundleIdentifier ?? "?"
        return OSLog(subsystem: defaultSubsystem, category: "\(self.rawValue)")
    }
}

extension GoLog {

    static func extraInfo(from options: [Option], filePath: String, functionName: String, lineNumber: Int) -> String {
        
        var extraInfo: String = ""
        
        guard !options.isEmpty else { return "" }
        
        var options = options
        if options.contains(.all) {
            options = Option.allCases
        }
        
        if options.contains(.fileAndLine) {
            let fileAndLine = "\((filePath as NSString).lastPathComponent):\(lineNumber)"
            extraInfo = extraInfo.isEmpty ? fileAndLine : "\(extraInfo) \(fileAndLine)"
        }
        
        if options.contains(.function) {
            extraInfo = extraInfo.isEmpty ? functionName : "\(extraInfo) \(functionName)"
        }
        
        return "[\(extraInfo)] - "
    }
}

