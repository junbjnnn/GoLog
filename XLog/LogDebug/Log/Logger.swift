//
//  Logger.swift
//  XLog
//
//  Created by NamDV on 8/24/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import class Foundation.NSString
import class Foundation.DateFormatter
import struct Foundation.Date
import class Foundation.Bundle
import SwiftLog
import os.log

public final class Logger {
    
    public static func log<T: CustomStringConvertible>(category: Category = .app,
                                                       type: OSLogType = .default,
                                                       _ message: T,
                                                       options: [Option] = [],
                                                       filePath: String = #file,
                                                       functionName: String = #function,
                                                       lineNumber: Int = #line) {
        
        let extraInfo: String = Logger.extraInfo(from: options,
                                                 filePath: filePath,
                                                 functionName: functionName,
                                                 lineNumber: lineNumber)
        
        os_log("%{public}s%{public}s%{public}s",
               log: category.osLog,
               type: type,
               type.description,
               extraInfo,
               message.description)
        Log.logger.write(type.description + extraInfo + " - " + message.description)
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

public extension Logger {
    struct Category {
        private var rawValue: String
        
        public static let app = Category("APP")
        public static let api = Category("API")
        public static let layout = Category("LAYOUT")
        
        init(_ rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    enum Option: CaseIterable {
        case fileAndLine
        case function
        case all
    }
}

public extension Logger.Category {
    var osLog: OSLog {
        let defaultSubsystem = Bundle.main.bundleIdentifier ?? "?"
        return OSLog(subsystem: defaultSubsystem, category: "\(self.rawValue)")
    }
}
