//
//  Extensions.swift
//  Tools
//
//  Created by Oleg Ketrar on 10.02.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

// MARK: - Array/Collection

public extension Collection {

    /// Map only unique items.
    func uniqueMap<T: Hashable>(_ transform: (Iterator.Element) throws -> T) rethrows -> [T] {
        return Array<T>( Set<T>(try map(transform)) )
    }

    /// Map only unique items.
    func uniqueCompactMap<T: Hashable>(_ transform: (Iterator.Element) throws -> T?) rethrows -> [T] {
        return Array<T>( Set<T>(try compactMap(transform)) )
    }

    /// Safelly returns element at index.
    /// Returns `nil` if out of bounds.
    /// - parameter index: Element index in collection.
    /// - returns: Element if index valid, otherwise nil.
    func item(at index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

// MARK: - Base64 encoding/decoding

public extension Data {

    init?(urlSafeBase64String: String) {
        let rem = urlSafeBase64String.utf8.count % 4

        var ending = ""
        if rem > 0 {
            let amount = 4 - rem
            ending = String(repeating: "=", count: amount)
        }

        let base64String = urlSafeBase64String.replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/") + ending

        self.init(base64Encoded: base64String)
    }

    func urlSafeBase64String() -> String? {
        let data = self.base64EncodedData(options: [])
        guard let string = String(data: data, encoding: String.Encoding.utf8) else { return nil }

        return string.replacingOccurrences(of: "+", with: "-", options: [], range: nil)
            .replacingOccurrences(of: "/", with: "_", options: [], range: nil)
            .replacingOccurrences(of: "=", with: "", options: [], range: nil)
    }
}

/// Call `closure` after `seconds` on `main` queue.
public func withDelay(_ seconds: TimeInterval, _ closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(seconds * 1000))) { closure() }
}

/// Call `closure` after standart time of animation (0.33 seconds).
/// Closure will be called on `main` queue.
public func withAnimationDelay(_ closure: @escaping () -> Void) {
    withDelay(0.33, closure)
}
