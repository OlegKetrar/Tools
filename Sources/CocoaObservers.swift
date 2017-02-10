//
//  CocoaObservers.swift
//  Tools
//
//  Created by Oleg Ketrar on 2/10/17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

class EventObserver {
    private var observers: [NSObjectProtocol] = []

    deinit {
        removeAll()
    }

    // MARK: - Public

    @discardableResult
    func add(forName name: Notification.Name, using closure: @escaping (Notification) -> Void) -> Self {
        observers.append(NotificationCenter.default.addObserver(forName: name, object: nil,
                                                                queue: .main, using: closure))
        return self
    }

    @discardableResult
    func removeAll() -> Self {
        observers.forEach { NotificationCenter.default.removeObserver($0) }
        observers.removeAll()
        return self
    }
}

class KeyboardObserver {
    private let observer = EventObserver()

    // MARK: - Public

    @discardableResult
    final func onWillShow(_ closure: @escaping (Notification) -> Void) -> Self {
        observer.add(forName: .UIKeyboardWillShow, using: closure)
        return self
    }

    @discardableResult
    final func onWillHide(_ closure: @escaping (Notification) -> Void) -> Self {
        observer.add(forName: .UIKeyboardWillHide, using: closure)
        return self
    }

    @discardableResult
    final func onDidShow(_ closure: @escaping (Notification) -> Void) -> Self {
        observer.add(forName: .UIKeyboardDidShow, using: closure)
        return self
    }

    @discardableResult
    final func onKeyboardDidHide(_ closure: @escaping (Notification) -> Void) -> Self {
        observer.add(forName: .UIKeyboardDidHide, using: closure)
        return self
    }
}

extension Notification {
    var keyboardFrame: CGRect? {
        return (userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
    }
}



