//
//  NotificationObserver.swift
//  ToolsFoundation
//
//  Created by Oleg Ketrar on 10.02.17.
//

import Foundation

/// Common NotificationCenter observer.
/// Saves all observers and unsubscribe them on deinit.
/// You need to retain observer. Otherwise observers will be unsubscribed.
public class NotificationObserver {
    private var center: NotificationCenter
    private var observers: [NSObjectProtocol]

    /// Instantiate observer with `NotificationCenter`
    /// - parameter center: notification center. `default` used by default.
    public init(center: NotificationCenter = .default) {
        self.center = center
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
        queue: OperationQueue = .main,
        using closure: @escaping (Notification) -> Void) -> Self {

        observers.append(center.addObserver(
            forName: name,
            object: object,
            queue: queue,
            using: closure))

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
