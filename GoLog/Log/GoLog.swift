//
//  GoLog.swift
//  GoLog
//
//  Created by NamDV on 8/24/20.
//  Copyright © 2020 ER. All rights reserved.
//

import class Foundation.NSString
import class Foundation.DateFormatter
import struct Foundation.Date
import class Foundation.Bundle
import SwiftLog
import os.log

public final class GoLog {
    
    static var debugMenuDelegate: AddOnDebugMenuDelegate?
    static var configuration: Configuration!
    public static var showDebugMenu: Bool = false {
        didSet {
            DebugMenu.shared.visibleDebugMenu(isShow: showDebugMenu)
        }
    }
    
    public struct Configuration {
        var logToFile = true
        var debugAppInfoText = ""
        var addOnDebugMenu = [AddOnDebugMenu]()
        var userDefaultsKeys = [LocalUserDefaultsKey]()
        
        public init(
            logToFile: Bool = true,
            debugAppInfoText: String = "",
            addOnDebugMenu: [AddOnDebugMenu] = [],
            userDefaultsKeys: [LocalUserDefaultsKey] = []
        ) {
            self.userDefaultsKeys = userDefaultsKeys
            self.addOnDebugMenu = addOnDebugMenu
            self.logToFile = logToFile
            self.debugAppInfoText = debugAppInfoText
        }
    }
    
    public static func setup(with configuration: Configuration, debugMenuDelegate: AddOnDebugMenuDelegate?) {
        GoLog.configuration = configuration
        GoLog.debugMenuDelegate = debugMenuDelegate
    }
    
    public static func log<T: CustomStringConvertible>(
        category: Category = .app,
        type: OSLogType = .default,
        _ message: T,
        options: [Option] = [],
        filePath: String = #file,
        functionName: String = #function,
        lineNumber: Int = #line
    ) {
        let extraInfo: String = GoLog.extraInfo(
            from: options,
            filePath: filePath,
            functionName: functionName,
            lineNumber: lineNumber
        )
        
        let string: StaticString = "%{public}s%{public}s%{public}s"
        os_log(string, log: category.osLog, type: type, type.description, extraInfo, message.description)
        if GoLog.configuration.logToFile {
            Log.logger.write(type.description + extraInfo + " - " + message.description)
        }
    }
}

public extension GoLog {
    
    static let environment: String = {
        var type: String = ""
        #if DEBUG
        type = "DEBUG"
        #elseif RELEASE
        type = "RELEASE"
        #endif
        return type
    }()
    
    static let uuidString = UIDevice.current.identifierForVendor?.uuidString ?? ""
    
    static func logAppInfo() {
        Log.logger.printToConsole = false
        
        GoLog.log(type: .info, "==============================")
        GoLog.log(type: .info, "✳️ Time : \(Date())")
        GoLog.log(type: .info,
                  "✳️ Device Name : \(UIDevice.current.name) - MODEL : \(UIDevice.current.model)")
        GoLog.log(type: .info, "✳️ Environment : \(environment)")
        GoLog.log(type: .info, "✳️ UUID : \(uuidString)")
        if let dict = Bundle.main.infoDictionary {
            if let version = dict["CFBundleShortVersionString"] as? String,
                let bundleVersion = dict["CFBundleVersion"] as? String,
                let appName = dict["CFBundleName"] as? String {
                GoLog.log(type: .info, "✳️ App Name : \(appName) - Version : \(version) (Build : \(bundleVersion))")
                GoLog.log(type: .info, "✳️ Sub System : \(Bundle.main.bundleIdentifier ?? "?")")
            }
            
            if let commit = dict["BuildTime"] as? String {
                GoLog.log(type: .info, "✳️ Build GIT INFO : \(commit)")
            }
        }
        GoLog.log(type: .info, "==============================")
    }
    
}
