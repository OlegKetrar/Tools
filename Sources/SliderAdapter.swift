//
//  SliderAdapter.swift
//  Tools
//
//  Created by Oleg Ketrar on 05.03.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import UIKit

public class SliderAdapter<Data, Cell: UICollectionViewCell>: NSObject, UICollectionViewDataSource,
    UICollectionViewDelegate, UICollectionViewDelegateFlowLayout where Data: Equatable, Cell: Reusable {

    fileprivate var countClosure: () -> Int                 = { 0 }
    fileprivate var dataClosure: (Int) -> Data?             = { _ in .none }
    fileprivate var cellClosure: (Cell, Data) -> Cell       = { (cell, _) in cell }
    fileprivate var onSelectionClosure: (Int, Cell) -> Void = { _ in }
    fileprivate var onPrefetchingClosure: (Int) -> Void     = { _ in }

    fileprivate var itemSizeClosure: ((Int) -> CGSize)?

    // MARK: UICollectionViewDataSource

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countClosure()
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as Cell

        guard let data = dataClosure(indexPath.row) else { return cell }
        return cellClosure(cell, data)
    }

    // MARK: UICollectionViewDelegate

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? Cell else { return }
        onSelectionClosure(indexPath.row, cell)
    }

    // MARK: UICollectionViewDelegateFlowLayout

    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if let closure = itemSizeClosure {
            return closure(indexPath.row)
        } else {
            return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? .zero
        }
    }

    // MARK: UICollectionViewDataSourcePrefetching

//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        guard let index = indexPaths.first?.row else { return }
//        onPrefetchingClosure(index)
//    }
}

// MARK: - Configure

public extension SliderAdapter {

    @discardableResult
    func with(dataCount: @autoclosure @escaping () -> Int) -> Self {
        countClosure = dataCount
        return self
    }

    @discardableResult
    func onConfigure(_ closure: @escaping (Cell, Data) -> Cell) -> Self {
        cellClosure = closure
        return self
    }

    @discardableResult
    func onData(_ closure: @escaping (Int) -> Data?) -> Self {
        dataClosure = closure
        return self
    }

    @discardableResult
    func onSelection(_ closure: @escaping (Int, Cell) -> Void) -> Self {
        onSelectionClosure = closure
        return self
    }

//    @discardableResult
//    func onPrefetching(_ closure: @escaping (Int) -> Void) -> Self {
//        onPrefetchingClosure = closure
//        return self
//    }

    @discardableResult
    func onCellSizing(_ closure: @escaping (Int) -> CGSize) -> Self {
        itemSizeClosure = closure
        return self
    }
}

// TODO: if RealmSwift available

//// MARK: - Realm Binding
//
//extension SliderAdapter where Data: Object {
//
//    @discardableResult
//    func bind(results: Results<Data>, to collectionView: UICollectionView) -> Self {
//        notificationToken = results.addNotificationBlock { [weak collectionView] (changes) in
//            collectionView?.reloadData()
//        }
//
//        return self
//    }
//}

// MARK: - UICollectionView Convenience

public extension UICollectionView {

    // TODO: if available iOS 10

    typealias Adapter = UICollectionViewDataSource & UICollectionViewDelegate

    @discardableResult
    func with(adapter: Adapter) -> Self {
        dataSource = adapter
        delegate   = adapter
        return self
    }
}
