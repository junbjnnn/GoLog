//
//  OSLogType+Extension.swift
//  GoLog
//
//  Created by Dung Tran Van on 10/18/20.
//  Copyright © 2020 GoLog. All rights reserved.
//

import Foundation
import os.log

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
