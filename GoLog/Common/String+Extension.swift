//
//  String+Extension.swift
//  GoLog
//
//  Created by NamDV on 10/13/20.
//  Copyright © 2020 ER. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func match(_ regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map {
                result.range(at: $0).location != NSNotFound
                    ? nsString.substring(with: result.range(at: $0))
                    : ""
            }
        }
    }
}
