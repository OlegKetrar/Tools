//
//  CocoaObservers.swift
//  Tools
//
//  Created by Oleg Ketrar on 10.02.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Common NotificationCenter observer

public class EventObserver {
	private var observers: [NSObjectProtocol]

	public init() {
		observers = []
	}

	deinit {
		removeAll()
	}

	// MARK: - Public
	@discardableResult
	public func add(forName name: Notification.Name,
	                object: AnyObject? = nil,
	                queue: DispatchQueue = .main,
	                using closure: @escaping (Notification) -> Void) -> Self {

		observers.append(NotificationCenter.default.addObserver(forName: name, object: nil,
		                                                        queue: .main, using: closure))
		return self
	}

	@discardableResult
	public func removeAll() -> Self {
		observers.forEach { NotificationCenter.default.removeObserver($0) }
		observers.removeAll()
		return self
	}
}

// MARK: - Keyboard events observer

/// Add block observers and release them
public class KeyboardObserver {
	private let shouldPreserveMultipleShowEvents: Bool

	private let observer: EventObserver = EventObserver()
	private var isShown: Bool           = false

	public init(preserveMultipleShowEvents: Bool = true) {
		shouldPreserveMultipleShowEvents = preserveMultipleShowEvents
	}

	// MARK: - Public

	/// - parameter closure: will be called only if keyboard changed content frame
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
    public var keyboardFrame: CGRect? {
        return (userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
    }
}
