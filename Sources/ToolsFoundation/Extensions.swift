//
//  Extensions.swift
//  ToolsFoundation
//
//  Created by Oleg Ketrar on 10.02.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

public extension Collection {

    /// Safelly returns element at index.
    /// Returns `nil` if out of bounds.
    /// - parameter index: Element index in collection.
    /// - returns: Element if index valid, otherwise nil.
    func item(at index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }

    /// Map only unique items.
    func uniqueMap<T: Hashable>(
        _ transform: (Iterator.Element) throws -> T) rethrows -> [T] {

        return Array<T>( Set<T>(try map(transform)) )
    }

    /// Map only unique items.
    func uniqueCompactMap<T: Hashable>(
        _ transform: (Iterator.Element) throws -> T?) rethrows -> [T] {

        return Array<T>( Set<T>(try compactMap(transform)) )
    }
}

extension RandomAccessCollection where Self: MutableCollection {

    mutating func sort<T: Comparable>(
        by keyPath: KeyPath<Element, T>,
        ascending: Bool = true) {

        sort(by: {
            ascending.xnor($0[keyPath: keyPath] < $1[keyPath: keyPath])
        })
    }

    mutating func sort(by keyPath: KeyPath<Element, Bool>, ascending: Bool = true) {

        sort(by: {
            let left = $0[keyPath: keyPath] ? 1 : 0
            let right = $1[keyPath: keyPath] ? 1 : 0

            return ascending.xnor(left < right)
        })
    }
}

private extension Bool {

    func xor(_ other: Bool) -> Bool {
        return (self && !other) || (!self && other)
    }

    func xnor(_ other: Bool) -> Bool {
        return !self.xor(other)
    }
}
