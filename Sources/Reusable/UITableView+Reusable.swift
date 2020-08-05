//
//  UITableView+Reusable.swift
//  Reusable
//
//  Created by Oleg Ketrar on 06.08.2020.
//

import Foundation
import UIKit

public extension UITableView {

    func register<T: UITableViewCell>(class: T.Type) where T: Reusable {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UITableViewCell>(nib: T.Type) where T: NibInitable {
        register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UITableViewHeaderFooterView>(
        headerFooterViewClass: T.Type) where T: Reusable {

        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UITableViewHeaderFooterView>(
        headerFooterViewNib: T.Type) where T: NibInitable {

        register(T.nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
}

public extension UITableView {

    func dequeue<T: UITableViewCell>(
        cell type: T.Type,
        for indexPath: IndexPath) -> T where T: Reusable {

        return dequeueCell(for: indexPath) as T
    }

    func dequeueCell<T: UITableViewCell>(
        for indexPath: IndexPath) -> T where T: Reusable {

        let cellOrNil = dequeueReusableCell(
            withIdentifier: T.reuseIdentifier,
            for: indexPath) as? T

        guard let cell = cellOrNil else {
            fatalError("""
                Can't dequeue reusable cell \(T.self) \
                with identifier \(T.reuseIdentifier)
                """)
        }

        return cell
    }

    func dequeue<T: UITableViewHeaderFooterView>(
        headerFooter type: T.Type) -> T where T: Reusable {

        return dequeueHeaderFooterView() as T
    }

    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>() -> T
    where T: Reusable {

        let headerFooterViewOrNil = dequeueReusableHeaderFooterView(
            withIdentifier: T.reuseIdentifier) as? T

        guard let view = headerFooterViewOrNil else {
            fatalError("""
                Can't dequeue reusable header/footer \(T.self) \
                with identifier \(T.reuseIdentifier)
                """)
        }

        return view
    }
}
