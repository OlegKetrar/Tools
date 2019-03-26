//
//  Switch.swift
//  Tools
//
//  Created by Oleg Ketrar on 04.07.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

// TODO: refactor
// TODO: add preloader for async enabling/disabling

/// Provides control on value changing.
public final class Switch: UISwitch {
    private var shouldChangeValueClosure: (Bool) -> Bool = { _ in true }

    private let emptyButton: UIButton = {
        return UIButton(frame: .zero)
    }()

    // MARK: - Overrides

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    private func configure() {
        addSubview(emptyButton)
        emptyButton.addTarget(self, action: #selector(actionTouchUpInside), for: .touchUpInside)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        emptyButton.frame = bounds
    }

    // MARK: - Actions

    @objc private func actionTouchUpInside() {
        let newValue = !isOn

        if shouldChangeValueClosure(newValue) {
            setOn(newValue, animated: true)
        }
    }

    /// Should change to switch newValue.
    /// - parameter closure: Will be called on `ValueChanged` event.
    /// Takes `newValue` and returns shouldChange.
    @discardableResult
    public func onShouldChangeValue(_ closure: @escaping (Bool) -> Bool) -> Self {
        shouldChangeValueClosure = closure
        return self
    }
}
