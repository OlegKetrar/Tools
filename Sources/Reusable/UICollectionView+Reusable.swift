//
//  UICollectionView+Reusable.swift
//  Reusable
//
//  Created by Oleg Ketrar on 06.08.2020.
//

import Foundation
import UIKit

public extension UICollectionView {

    func register<T: UICollectionViewCell>(class: T.Type) where T: Reusable {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionViewCell>(nib: T.Type) where T: NibInitable {
        register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionReusableView>(
        class: T.Type,
        forSupplementaryViewOfKind kind: String) where T: Reusable {

        register(
            T.self,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionReusableView>(
        nib: T.Type,
        forSupplementaryViewOfKind kind: String) where T: NibInitable {

        register(
            T.nib,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: T.reuseIdentifier)
    }
}

public extension UICollectionView {

    func dequeue<T: UICollectionViewCell>(
        cell type: T.Type,
        for indexPath: IndexPath) -> T where T: Reusable {

        return dequeueCell(for: indexPath) as T
    }

    func dequeueCell<T: UICollectionViewCell>(
        for indexPath: IndexPath) -> T where T: Reusable {

        let cellOrNil = dequeueReusableCell(
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath) as? T

        guard let cell = cellOrNil else {
            fatalError("""
                Can't dequeue reusable cell \(T.self) \
                with identifier \(T.reuseIdentifier)
                """)
        }

        return cell
    }

    func dequeueSupplementaryView<T: UICollectionReusableView>(
        ofKind kind: String,
        for indexPath: IndexPath) -> T where T: Reusable {

        let viewOrNil = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath) as? T

        guard let view = viewOrNil else {
            fatalError("""
                Can't dequeue reusable view of kind \(kind) \
                with identifier \(T.reuseIdentifier)
                """)
        }

        return view
    }
}
