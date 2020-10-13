//
//  Logger+Extention.swift
//  XLog
//
//  Created by NamDV on 8/28/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import UIKit
import SwiftLog

class LoggerHelper {
    
    static let environment: String = {
        let type: String
        #if DEBUG
        type = "DEBUG"
        #elseif STAGING
        type = "STAGING"
        #elseif RELEASE
        type = "RELEASE"
        #endif
        return type
    }()
    
    static let uuidString = UIDevice.current.identifierForVendor?.uuidString ?? ""

    static func logAppInfo() {
        Log.logger.printToConsole = false
        
        Logger.log(type: .info, "==============================")
        Logger.log(type: .info, "✳️ Time : \(Date())")
        Logger.log(type: .info,
                   "✳️ Device Name : \(UIDevice.current.name) - MODEL : \(UIDevice.current.model)")
        Logger.log(type: .info, "✳️ Environment : \(environment)")
        Logger.log(type: .info, "✳️ UUID : \(uuidString)")
        if let dict = Bundle.main.infoDictionary {
            if let version = dict["CFBundleShortVersionString"] as? String,
                let bundleVersion = dict["CFBundleVersion"] as? String,
                let appName = dict["CFBundleName"] as? String {
                Logger.log(type: .info, "✳️ App Name : \(appName) - Version : \(version) (Build : \(bundleVersion))")
                Logger.log(type: .info, "✳️ Sub System : \(Bundle.main.bundleIdentifier ?? "?")")
            }
            
            if let commit = dict["BuildTime"] as? String {
                Logger.log(type: .info, "✳️ Build GIT INFO : \(commit)")
            }
        }
        Logger.log(type: .info, "==============================")
    }
    
}
