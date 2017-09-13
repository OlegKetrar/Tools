//
//  SliderAdapter.swift
//  Tools
//
//  Created by Oleg Ketrar on 05.03.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import UIKit

// TODO: add docs.

public final class SliderAdapter<Data, Cell: UICollectionViewCell>: NSObject, UICollectionViewDataSource,
    UICollectionViewDelegate, UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout
where Data: Equatable, Cell: Reusable {

    fileprivate var countClosure: () -> Int                 = { 0 }
    fileprivate var dataClosure: (Int) -> Data?             = { _ in .none }
    fileprivate var cellClosure: (Cell, Data) -> Cell       = { (cell, _) in cell }
    fileprivate var onSelectionClosure: (Int, Cell) -> Void = { _ in }
    fileprivate var onPrefetchingClosure: (Int) -> Void     = { _ in }

    fileprivate var itemSizeClosure: ((Int, Data) -> CGSize)?

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

        guard let closure = itemSizeClosure, let data = dataClosure(indexPath.row) else {
            return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? .zero
        }

        return closure(indexPath.row, data)
    }

    // MARK: UICollectionViewDataSourcePrefetching

    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let index = indexPaths.first?.row else { return }
        onPrefetchingClosure(index)
    }
}

// MARK: Configure

extension SliderAdapter {

    @discardableResult
    public func with(dataCount: @autoclosure @escaping () -> Int) -> Self {
        countClosure = dataCount
        return self
    }

    @discardableResult
    public func onConfigure(_ closure: @escaping (Cell, Data) -> Cell) -> Self {
        cellClosure = closure
        return self
    }

    @discardableResult
    public func onData(_ closure: @escaping (Int) -> Data?) -> Self {
        dataClosure = closure
        return self
    }

    @discardableResult
    public func onSelection(_ closure: @escaping (Int, Cell) -> Void) -> Self {
        onSelectionClosure = closure
        return self
    }

    @discardableResult
    public func onPrefetching(_ closure: @escaping (Int) -> Void) -> Self {
        onPrefetchingClosure = closure
        return self
    }

    @discardableResult
    public func onCellSizing(_ closure: @escaping (Int, Data) -> CGSize) -> Self {
        itemSizeClosure = closure
        return self
    }
}

// MARK: UICollectionView Convenience

public extension UICollectionView {

    public typealias Adapter = UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDataSourcePrefetching

    @discardableResult
    public func with(adapter: Adapter) -> Self {
        dataSource = adapter
        delegate   = adapter

        if #available(iOS 10.0, *) {
            prefetchDataSource = adapter
        }

        return self
    }
}

/*
 // MARK: - Updater

 struct Updater {

 enum ChangeSet {
 case initial
 case update(deleted: [Int], inserted: [Int], modified: [Int])
 case error(Error)
 }

 let changes: ChangeSet
 }

 extension Updater {

 func update(tableView: UITableView?) {
 guard let tableView = tableView else { return }

 switch changes {
 case .initial:
 tableView.reloadData()

 case let .update(deletions, insertions, modifications):
 tableView.beginUpdates()

 tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .fade)
 tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .bottom)
 tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .fade)

 tableView.endUpdates()

 default:
 break
 }
 }
 }

 extension Updater {
 func update(collectionView: UICollectionView?) {
 }
 }

 // MARK: -

 extension Updater.ChangeSet {
 init<T>(_ realmChanges: RealmCollectionChange<T>) {
 switch realmChanges {
 case .initial:
 self = .initial

 case let .update(_, deletions: deletions, insertions: insertions, modifications: modification):
 self = .update(deleted: deletions, inserted: insertions, modified: modification)

 case let .error(error):
 self = .error(error)
 }
 }
 }
 */
