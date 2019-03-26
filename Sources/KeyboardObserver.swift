//
//  KeyboardObserver.swift
//  Tools
//
//  Created by Oleg Ketrar on 13.09.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

// TODO: refactor user experience.

/// Add block observers and release them.
public class KeyboardObserver {
    private let shouldPreserveMultipleShowEvents: Bool

    private let observer = NotificationObserver()
    private var isShown  = false

    public init(preserveMultipleShowEvents: Bool = true) {
        shouldPreserveMultipleShowEvents = preserveMultipleShowEvents
    }

    /// - parameter closure: will be called only if keyboard changed content frame.
    @discardableResult
    public final func onWillShow(_ closure: @escaping (Notification) -> Void) -> Self {
        observer.add(forName: .UIKeyboardWillShow, using: { [weak self] (notification) in
            guard let strongSelf = self else { return }

            if strongSelf.shouldPreserveMultipleShowEvents {
                guard !strongSelf.isShown else { return }
            }

            closure(notification)
            strongSelf.isShown = true
        })

        return self
    }

    @discardableResult
    public final func onWillHide(_ closure: @escaping (Notification) -> Void) -> Self {
        observer.add(forName: .UIKeyboardWillHide, using: { [weak self] (notification) in
            guard let strongSelf = self else { return }

            if strongSelf.shouldPreserveMultipleShowEvents {
                guard strongSelf.isShown else { return }
            }

            closure(notification)
            strongSelf.isShown = false
        })
        return self
    }

    @discardableResult
    public final func onDidShow(_ closure: @escaping (Notification) -> Void) -> Self {
        observer.add(forName: .UIKeyboardDidShow, using: closure)
        return self
    }

    @discardableResult
    public final func onDidHide(_ closure: @escaping (Notification) -> Void) -> Self {
        observer.add(forName: .UIKeyboardDidHide, using: closure)
        return self
    }
}

public extension Notification {
    var keyboardFrame: CGRect? {
        return (userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
    }
}
