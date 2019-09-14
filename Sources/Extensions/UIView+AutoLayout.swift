//
//  UIView+AutoLayout.swift
//  ToolsUIKit
//
//  Created by Oleg Ketrar on 12.01.18.
//  Copyright © 2018 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {

    @discardableResult
    func addPinConstraint(
        toSubview subview: UIView,
        attribute: NSLayoutConstraint.Attribute,
        withSpacing spacing: CGFloat) -> NSLayoutConstraint {

        subview.translatesAutoresizingMaskIntoConstraints = false

        let constraint = NSLayoutConstraint(
            item: subview,
            attribute: attribute,
            relatedBy: .equal,
            toItem: self,
            attribute: attribute,
            multiplier: 1.0,
            constant: spacing)

        addConstraint(constraint)
        return constraint
    }

    @discardableResult
    func addPinConstraints(
        toSubview subview: UIView,
        withSpacing spacing: CGFloat = 0.0) -> [NSLayoutConstraint] {

        return [
            addPinConstraint(toSubview: subview, attribute: .left, withSpacing: spacing),
            addPinConstraint(toSubview: subview, attribute: .top, withSpacing: spacing),
            addPinConstraint(toSubview: subview, attribute: .right, withSpacing: -spacing),
            addPinConstraint(toSubview: subview, attribute: .bottom, withSpacing: -spacing)
        ]
    }

    func addPinnedSubview(_ subview: UIView, withSpacing spacing: CGFloat = 0.0) {
        addSubview(subview)
        translatesAutoresizingMaskIntoConstraints = false
        addPinConstraints(toSubview: subview, withSpacing: spacing)
    }

    func addPinnedSubview(_ subview: UIView, withInsets insets: UIEdgeInsets) {
        addSubview(subview)
        translatesAutoresizingMaskIntoConstraints = false
        subview.pinToSuperview(insets: insets)
    }

    @discardableResult
    func pinToSuperview(
        attribute: NSLayoutConstraint.Attribute,
        spacing: CGFloat = 0) -> NSLayoutConstraint? {

        return superview?.addPinConstraint(
            toSubview: self,
            attribute: attribute,
            withSpacing: spacing)
    }

    @discardableResult
    func pinToSuperview(insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        return [
            pinToSuperview(attribute: .left, spacing: insets.left),
            pinToSuperview(attribute: .top, spacing: insets.top),
            pinToSuperview(attribute: .right, spacing: -insets.right),
            pinToSuperview(attribute: .bottom, spacing: -insets.bottom)
        ]
        .compactMap { $0 }
    }
}
