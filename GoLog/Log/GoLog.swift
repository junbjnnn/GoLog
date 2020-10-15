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
    
    public internal(set) static var configuration: Configuration!
    
    public struct Configuration {
        public static var logToFile = true
        var userDefaultsKeys: [LocalUserDefaultsKey] = []
        
        public init(userDefaultsKeys: [LocalUserDefaultsKey]) {
            self.userDefaultsKeys = userDefaultsKeys
        }
    }
    
    public static func setup(with configuration: Configuration) {
        GoLog.configuration = configuration
    }
    
    public static func log<T: CustomStringConvertible>(category: Category = .app,
                                                       type: OSLogType = .default,
                                                       _ message: T,
                                                       options: [Option] = [],
                                                       filePath: String = #file,
                                                       functionName: String = #function,
                                                       lineNumber: Int = #line) {
        
        let extraInfo: String = GoLog.extraInfo(from: options,
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
    
    public struct LocalUserDefaultsKey {
        var key: String
        var description: String?
        
        public init(key: String) {
            self.key = key
        }
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

public extension GoLog {
    public struct Category: Equatable {
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
