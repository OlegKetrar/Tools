//
//  StringExtensions.swift
//  ToolsFoundation
//
//  Created by Oleg Ketrar on 25/12/2018.
//  Copyright © 2018 Oleg Ketrar. All rights reserved.
//

import Foundation

public extension String {

    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func localized(with bundle: Bundle?) -> String {
        guard let bundle = bundle else { return localized }
        return bundle.localizedString(forKey: self, value: "", table: nil)
    }

    /// Validate with `regex`.
    func validate(regex regStr: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regStr).evaluate(with: self)
    }

    var ns: NSString {
        return self as NSString
    }

    func removingSuffix(_ suffix: String) -> String {
        guard !suffix.isEmpty, hasSuffix(suffix) else { return self }

        var copy = self
        for char in suffix.reversed() {
            guard copy.last == char else { break }
            copy.removeLast()
        }

        return copy
    }

    func removingPrefix(_ prefix: String) -> String {
        guard !prefix.isEmpty, hasPrefix(prefix) else { return self }

        var copy = self
        for char in prefix {
            guard copy.first == char else { break }
            copy.removeFirst()
        }

        return copy
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
        return self ?? ""
    }
}
