//
//  Reusable.swift
//  Reusable
//
//  Created by Oleg Ketrar on 10.02.17.
//

import Foundation

/// Type which have `reuseIdentifier`.
/// By default it is a type name.
/// Used for `UITableView` & `UICollectionView` cells,
/// which declare its UI in the storyboard.
public protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

public extension Reusable {

    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
