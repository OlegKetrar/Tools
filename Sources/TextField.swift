//
//  TextField.swift
//  Tools
//
//  Created by Oleg Ketrar on 18.08.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

/*
/// TextField.
public final class TextField: UITextField {
    fileprivate var observer: NotificationObserver?
    fileprivate var validateClosure: (String, Bool) -> Bool = { _, _ in true }

    ///

    fileprivate let placeholderLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    fileprivate let detailLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    fileprivate let separatorView: UIView = {
        let separator = UIView()
        return separator
    }()

    // MARK: Placeholder

    public var placeholderFont: UIFont {
        get { return placeholderLabel.font }
        set { placeholderLabel.font = newValue }
    }

    public var placeholderColor: UIColor {
        get { return placeholderLabel.textColor }
        set { placeholderLabel.textColor = newValue }
    }

    override public var placeholder: String? {
        get { return placeholderLabel.text }
        set { placeholderLabel.text = newValue }
    }

    override public var attributedPlaceholder: NSAttributedString? {
        get { return placeholderLabel.attributedText }
        set { placeholderLabel.attributedText = newValue }
    }

    //	public var placeholder

    // MARK: Detail

    public var detailFont: UIFont {
        get { return detailLabel.font }
        set { detailLabel.font = newValue }
    }

    public var detailColor: UIColor {
        get { return detailLabel.textColor }
        set { detailLabel.textColor = newValue }
    }

    public var detail: String? {
        get { return detailLabel.text }
        set { detailLabel.text = newValue }
    }

    public var attributedDetail: NSAttributedString? {
        get { return detailLabel.attributedText }
        set { detailLabel.attributedText = newValue }
    }

    // MARK: Separator

    public var separatorColor: UIColor {
        get { return separatorView.backgroundColor ?? .clear }
        set { separatorView.backgroundColor = newValue }
    }

    public var separatorThickness: CGFloat = 1 {
        didSet { setNeedsLayout() }
    }

    public var separatorInsets: UIEdgeInsets = .zero {
        didSet { setNeedsLayout() }
    }

    // MARK: Normal/Active state

    public var separatorNormalColor: UIColor = .black {
        didSet {
            guard isEditing else { return }
            separatorColor = separatorNormalColor
        }
    }

    public var separatorActiveColor: UIColor = .black {
        didSet {
            guard isEditing else { return }
            separatorColor = separatorActiveColor
        }
    }
}

// MARK: Styling

/// Defines TextField style.
/// No implementation means default style.
public protocol TextFieldStyle {
    func apply(to textField: TextField)
}

extension TextField {

    /// Applies specified style to text field.
    /// - parameter style: applied style.
    @discardableResult
    public func apply(style: TextFieldStyle) -> Self {
        style.apply(to: self)
        return self
    }
}

// MARK: Validation

/// Validation.
public struct Validation {

    static var notEmptyMessage: String      = ""
    static var atLeastMessageFormat: String = ""
    static var atMostMessageFormat: String  = ""
    static var invalidEmailMessage: String  = ""

    // TODO: inject default style config for default conditions

    /// Condition.
    public struct Condition {
        var regex: String   = "."
        var message: String = ""
    }
}

extension TextField {

    /// Adds `condition` to validate on `textDidChanged`.
    /// Text field will check all validation conditions in the order in which you add it.
    /// - parameter condition: `text` will be validated by `condition.regex` on `textFieldDidChanged`
    /// and `condition.message` will be shown if `text` not valid.
    /// - parameter conditionStyle: style which will be applied if the `condition` is not met.
    @discardableResult
    public func add(condition: Validation.Condition, withStyle conditionStyle: TextFieldStyle) -> Self {
        let previousCondition = validateClosure

        // compose new condition with existing
        validateClosure = { [weak self] (str, shouldBounce) in
            guard let strongSelf = self else { return true }

            // chech previous conditions
            guard previousCondition(str, shouldBounce) else { return false }

            // validate condition
            if str.validate(regex: condition.regex){
                // TODO: hide detail label
                return true

            } else {
                strongSelf.apply(style: conditionStyle)

                /*
                 if shouldBounce {
                 strongSelf.detailLabel.bounce(scale: 1.2)
                 }
                 */

                return false
            }
        }

        // start observing textDidChanged if not observed yet
        if observer == nil {
            observer = NotificationObserver().add(forName: .UITextFieldTextDidChange) { [weak self] (n) in
                guard let textField = n.object as? TextField,
                    let strongSelf = self,
                    textField === strongSelf else { return }

                strongSelf.validate(bounceOnError: false)
            }
        }

        return self
    }

    /// Removes all validation conditions.
    @discardableResult
    public func removeAllConditions() -> Self {
        validateClosure = { _ in true }
        return self
    }

    /// Trigger validation manually. Shows `detail` if not valid.
    /// - parameter bounceOnError: perform bounce animation if `true`.
    @discardableResult
    public func validate(bounceOnError: Bool = false) -> Bool {
        return validateClosure(text.orEmpty, bounceOnError)
    }
}

// MARK: Predefined validation Conditions

extension Validation.Condition {

    /// Should contain at least one character.
    static var notEmpty: Validation.Condition {
        return Validation.Condition(
            regex: ".{1,}",
            message: Validation.notEmptyMessage
        )
    }

    /// Should contain at least characters count.
    /// - parameter count: minimum count of characters.
    static func atLeast(_ count: Int) -> Validation.Condition {
        return Validation.Condition(
            regex: ".{\(count),}",
            message: String(format: Validation.atLeastMessageFormat, "\(count)")
        )
    }

    /// Should contain at most characters count.
    /// - parameter count: maximum count of characters.
    static func atMost(_ count: Int) -> Validation.Condition {
        return Validation.Condition(
            regex: ".{0,\(count)}",
            message: String(format: Validation.atMostMessageFormat, "\(count)")
        )
    }

    /// Should be valid email address.
    static var emailField: Validation.Condition {
        return Validation.Condition(
            regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
            message: Validation.invalidEmailMessage
        )
    }
}
*/

// MARK: Predifined styles

/*
 private extension UIView {
 func bounce(scale scaleFactor: CGFloat) {
 UIView.animate(withDuration: 0.13, delay: 0, options: [.curveEaseInOut], animations: {
 self.layer.transform = CATransform3DScale(CATransform3DIdentity, scaleFactor, scaleFactor, 1)
 }, completion: { _ in
 UIView.animate(withDuration: 0.07) { self.layer.transform = CATransform3DIdentity }
 })
 }
 }
 */
