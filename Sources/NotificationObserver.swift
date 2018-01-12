//
//  CocoaObservers.swift
//  Tools
//
//  Created by Oleg Ketrar on 10.02.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

@available(iOS, deprecated, message: "use NotificationObserver")
public typealias EventObserver = NotificationObserver

/// Common NotificationCenter observer.
/// Saves all observers and unsubscribe them on dealloc.
/// You need to retain observer. Otherwise observers will be unsubscribed.
public class NotificationObserver {
    private var center: NotificationCenter
    private var observers: [NSObjectProtocol]

    /// Instantiate observer with `NotificationCenter`
    /// - parameter center: notification center. `default` used by default.
    public init(center: NotificationCenter = .default) {
        self.center    = center
        self.observers = []
    }

    deinit {
        removeAll()
    }

    /// Add observer.
    /// - parameter name: Notification name.
    /// - parameter object: Object.
    /// - parameter queue: Queue on which `closure` will be called.
    /// - parameter closure: Closure which would be called on specified notification.
    @discardableResult
    public func add(
        forName name: Notification.Name,
        object: AnyObject? = nil,
        queue: DispatchQueue = .main,
        using closure: @escaping (Notification) -> Void) -> Self {

        observers.append(center.addObserver(forName: name, object: nil, queue: .main, using: closure))
        return self
    }

    /// Unsubscribe all associated observers.
    @discardableResult
    public func removeAll() -> Self {
        observers.forEach { center.removeObserver($0) }
        observers.removeAll()
        return self
    }
}