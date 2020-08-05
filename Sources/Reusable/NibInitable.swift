//
//  NibInitable.swift
//  Reusable
//
//  Created by Oleg Ketrar on 06.08.2020.
//

import Foundation
import UIKit

/// Type which can be instantiated with `NIB`.
/// By default `nibName` is a type name.
/// Nib should be located in the same bundle where type declared.
/// Used for `UITableView` & `UICollectionView` cells,
/// which declare its UI in a separate `NIB`.
public protocol NibInitable: Reusable {
    static var nibName: String { get }
}

public extension NibInitable {

    static var nibName: String {
        return String(describing: Self.self)
    }

    static var nib: UINib {
        return UINib(nibName: nibName, bundle: Bundle(for: self))
    }
}

public extension UIView {

    /// Layout strategy for `replaceWithNib` method.
    enum LayoutStrategy {
        case autoLayout
        case autoresizingMask
    }
}

// MARK: - Reusable UIView (loaded from nib)

public extension NibInitable where Self: UIView {

    /// Replace view with appropriate nib loaded view.
    /// - parameter strategy: Layout strategy for asigning view from `NIB`.
    /// `autoLayout` by default.
    /// + *set File's Owner to view class*
    /// + *setup Auto Layout*
    /// + *link iboutlets*
    /// + *override view initializers like*:
    /// ```
    /// override init(frame: CGRect) {
    ///     super.inir(frame: frame)
    ///     replaceWithNib()
    ///     // additional setup
    /// }
    ///
    /// required init(coder aDecoder: NSCoder) {
    ///     super.init(coder: aDecoder)
    ///     replaceWithNib()
    ///     // additional setup
    /// }
    ///
    /// ```
    func replaceWithNib(with strategy: UIView.LayoutStrategy = .autoLayout) {

        // load appropriate view from Nib
        if let view = Self.nib.instantiate(withOwner: self)[0] as? UIView {
            view.backgroundColor = .clear
            view.isOpaque = false
            view.clipsToBounds = true

            addSubview(view)

            switch strategy {
            case .autoLayout:
                view.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    view.leftAnchor.constraint(equalTo: leftAnchor),
                    view.topAnchor.constraint(equalTo: topAnchor),
                    view.rightAnchor.constraint(equalTo: rightAnchor),
                    view.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])

            case .autoresizingMask:
                view.frame = bounds
                view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            }
        }
    }
}
