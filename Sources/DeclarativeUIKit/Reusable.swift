//
//  Reusable.swift
//  Tools
//
//  Created by Oleg Ketrar on 10.02.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

/// Type which have `reuseIdentifier`.
/// By default it is a type name.
/// Used for `UITableView` & `UICollectionView` cells,
/// which declare its UI in the storyboard.
public protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

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
        if let reusableView = Self.nib.instantiate(withOwner: self, options: nil)[0] as? UIView {
            reusableView.backgroundColor = .clear
            reusableView.isOpaque        = false
            reusableView.clipsToBounds   = true

            if case .autoLayout = strategy {
                addPinnedSubview(reusableView)
            } else {
                reusableView.frame = bounds
                reusableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                addSubview(reusableView)
            }
        }
    }
}

// MARK: - Reusable UITableViewCell & UICollectionViewCell

public extension UITableView {

    func dequeueCell<T>(for indexPath: IndexPath) -> T where T: UITableViewCell & Reusable {

        guard let cell = dequeueReusableCell(
            withIdentifier: T.reuseIdentifier,
            for: indexPath) as? T
        else {
            fatalError("Can't dequeue reusable cell \(T.self) with identifier \(T.reuseIdentifier)")
        }

        return cell
    }

    func dequeue<T>(
        cell type: T.Type,
        for indexPath: IndexPath) -> T where T: UITableViewCell & Reusable {

        return dequeueCell(for: indexPath) as T
    }

    func dequeueHeaderFooterView<T>() -> T where T: UITableViewHeaderFooterView & Reusable {

        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Can't dequeue reusable header/footer \(T.self) with identifier \(T.reuseIdentifier)")
        }

        return headerFooterView
    }

    func dequeue<T>(headerFooter type: T.Type) -> T where T: UITableViewHeaderFooterView & Reusable {
        return dequeueHeaderFooterView() as T
    }

    func register<T>(nib: T.Type) where T: UITableViewCell & NibInitable {
        register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func register<T>(class: T.Type) where T: UITableViewCell & Reusable {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func register<T>(headerFooterViewNib: T.Type) where T: UITableViewHeaderFooterView & NibInitable {
        register(T.nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    func register<T>(headerFooterViewClass: T.Type) where T: UITableViewHeaderFooterView & Reusable {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
}

public extension UICollectionView {

    func dequeueSupplementaryView<T: UICollectionReusableView>(
        ofKind kind: String,
        for indexPath: IndexPath) -> T where T: Reusable {

        let viewOrNil = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath) as? T

        guard let view = viewOrNil else {
            fatalError("Can't dequeue reusable view of kind \(kind) with identifier \(T.reuseIdentifier)")
        }

        return view
    }

    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: Reusable {

        let cellOrNil = dequeueReusableCell(
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath) as? T

        guard let cell = cellOrNil else {
            fatalError("Can't dequeue reusable cell \(T.self) with identifier \(T.reuseIdentifier)")
        }

        return cell
    }

    func dequeue<T>(
        cell type: T.Type,
        for indexPath: IndexPath) -> T where T: UICollectionViewCell & Reusable {

        return dequeueCell(for: indexPath) as T
    }

    func register<T: UICollectionViewCell>(nib: T.Type) where T: NibInitable {
        register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionViewCell>(class: T.Type) where T: Reusable {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionReusableView>(
        nib: T.Type,
        forSupplementaryViewOfKind kind: String) where T: NibInitable {
        
        register(
            T.nib,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionReusableView>(
        class: T.Type,
        forSupplementaryViewOfKind kind: String) where T: Reusable {

        register(
            T.self,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: T.reuseIdentifier)
    }
}

// MARK: - Reusable UIViewController

public extension UIStoryboard {

    /// Instantiate appropriate view controller.
    /// View controller `StoryboardID` must be the same
    /// as a view controller class name.
    func instantiateViewController<T>() -> T where T: UIViewController & Reusable {
        guard let vc = instantiateViewController(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Can't instantiate view controller \(T.self) with identifier \(T.reuseIdentifier)")
        }
        return vc
    }
}

public protocol StoryboardInitable: Reusable {

    /// Storyboard file name without extension.
    static var storyboardName: String { get }

    /// Storyboard bundle, main bundle used by default.
    static var storyboardBundle: Bundle? { get }
}

public extension StoryboardInitable where Self: UIViewController {

    static var storyboardBundle: Bundle? { return nil }

    /// Instantiate view controller from appropriate storyboard.
    /// View controller Storyboard ID must be the same
    /// as a view controller class name.
    static func instantiateViaStoryboard() -> Self {

        let storyboard = UIStoryboard(
            name: storyboardName,
            bundle: storyboardBundle)

        return storyboard.instantiateViewController() as Self
    }
}
