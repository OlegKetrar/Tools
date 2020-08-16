//
//  StringExtensions.swift
//  ToolsFoundation
//
//  Created by Oleg Ketrar on 25/12/2018.
//

import Foundation

extension String {

    public func removingSuffix(_ suffix: String) -> String {
        guard !suffix.isEmpty, hasSuffix(suffix) else { return self }

        var copy = self
        for char in suffix.reversed() {
            guard copy.last == char else { break }
            copy.removeLast()
        }

        return copy
    }

    public func removingPrefix(_ prefix: String) -> String {
        guard !prefix.isEmpty, hasPrefix(prefix) else { return self }

        var copy = self
        for char in prefix {
            guard copy.first == char else { break }
            copy.removeFirst()
        }

        return copy
    }
}

extension String {

    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    public func localized(with bundle: Bundle?) -> String {
        guard let bundle = bundle else { return localized }
        return bundle.localizedString(forKey: self, value: "", table: nil)
    }
}

// MARK: - NSString

extension String {

    public var ns: NSString {
        return self as NSString
    }
}

extension NSString {

    public func safeSubstring(with range: NSRange) -> String? {
        guard range.location < length else { return nil }
        return substring(with: range)
    }
}

// MARK: - Optional<String>

extension Optional where Wrapped == String {

    public var orEmpty: String {
        return self ?? ""
    }
}
