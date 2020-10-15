//
//  XLog.swift
//  XLog
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

public final class XLog {
    
    struct Configuration {
        public static var logToFile = true
    }
    
    public static func log<T: CustomStringConvertible>(category: Category = .app,
                                                       type: OSLogType = .default,
                                                       _ message: T,
                                                       options: [Option] = [],
                                                       filePath: String = #file,
                                                       functionName: String = #function,
                                                       lineNumber: Int = #line) {
        
        let extraInfo: String = XLog.extraInfo(from: options,
                                                 filePath: filePath,
                                                 functionName: functionName,
                                                 lineNumber: lineNumber)
        
        os_log("%{public}s%{public}s%{public}s",
               log: category.osLog,
               type: type,
               type.description,
               extraInfo,
               message.description)
        
        if Configuration.logToFile {
            Log.logger.write(type.description + extraInfo + " - " + message.description)
        }
    }
    
    // Convenience
    private static func extraInfo(from options: [Option], filePath: String, functionName: String, lineNumber: Int) -> String {
        
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

extension OSLogType: CustomStringConvertible {
    public var description: String {
        switch self {
        case OSLogType.debug:
            return "💬 DEBUG: "
        case OSLogType.default:
            return "✍️ DEFAULT: "
        case OSLogType.error:
            return "❌ ERROR: "
        case OSLogType.fault:
            return "🔥 FAULT: "
        case OSLogType.info:
            return "ℹ️ INFO: "
        default: return "?"
        }
    }
}

public extension XLog {
    struct Category: Equatable {
        private var rawValue: String
        
        public static let app = Category("APP")
        public static let api = Category("API")
        public static let layout = Category("LAYOUT")
        
        init(_ rawValue: String) {
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

public extension XLog.Category {
    var osLog: OSLog {
        let defaultSubsystem = Bundle.main.bundleIdentifier ?? "?"
        return OSLog(subsystem: defaultSubsystem, category: "\(self.rawValue)")
    }
}

public extension XLog {
    
    static let environment: String = {
        let type: String
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
        
        XLog.log(type: .info, "==============================")
        XLog.log(type: .info, "✳️ Time : \(Date())")
        XLog.log(type: .info,
                   "✳️ Device Name : \(UIDevice.current.name) - MODEL : \(UIDevice.current.model)")
        XLog.log(type: .info, "✳️ Environment : \(environment)")
        XLog.log(type: .info, "✳️ UUID : \(uuidString)")
        if let dict = Bundle.main.infoDictionary {
            if let version = dict["CFBundleShortVersionString"] as? String,
                let bundleVersion = dict["CFBundleVersion"] as? String,
                let appName = dict["CFBundleName"] as? String {
                XLog.log(type: .info, "✳️ App Name : \(appName) - Version : \(version) (Build : \(bundleVersion))")
                XLog.log(type: .info, "✳️ Sub System : \(Bundle.main.bundleIdentifier ?? "?")")
            }
            
            if let commit = dict["BuildTime"] as? String {
                XLog.log(type: .info, "✳️ Build GIT INFO : \(commit)")
            }
        }
        XLog.log(type: .info, "==============================")
    }
    
}
