//
//  StringExtensions.swift
//  Tools
//
//  Created by Oleg Ketrar on 25/12/2018.
//  Copyright © 2018 Oleg Ketrar. All rights reserved.
//

import Foundation

public extension String {

    /// Validate with `regex`.
    func validate(regex regStr: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regStr).evaluate(with: self)
    }

    var encodeBase64: String {
        return self.data(using: .utf8)?.base64EncodedString(options: []) ?? ""
    }

    var decodeBase64: String {
        guard let strData = Data(base64Encoded: self, options: []) else { return "" }
        return (NSString(data: strData, encoding: String.Encoding.utf8.rawValue) ?? "") as String
    }
}

public extension NSString {
    func safeSubstring(with range: NSRange) -> String? {
        guard range.location < length else { return nil }
        return substring(with: range)
    }
}

public extension Optional where Wrapped == String {
    var orEmpty: String {
        guard case let .some(value) = self else { return "" }
        return value
    }
}
