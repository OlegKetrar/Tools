//
//  SearchController.swift
//  ToolsUIKit
//
//  Created by Oleg Ketrar on 10.02.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

// TODO: refactor docs

// MARK: - Searchable (entities)

public protocol Searchable {
    var searchTags: [String] { get }
    func match(predicateStr: String, caseInsensitive: Bool) -> Bool
}

public extension Searchable {

    func match(predicateStr: String, caseInsensitive: Bool = true) -> Bool {
        guard !predicateStr.isEmpty else { return true }

        let withoutWhitespaces = predicateStr.trimmingCharacters(in: .whitespacesAndNewlines)

        if caseInsensitive {
            return searchTags
                .filter { $0.lowercased().contains(withoutWhitespaces.lowercased()) }
                .count > 0
        } else {
            return searchTags.filter { $0.contains(withoutWhitespaces) }.count > 0
        }
    }
}

// MARK: - Convenience for searchable entity collection

public extension Array where Element: Searchable {

    func match(predicate: String, caseInsensitive: Bool = true) -> Array {
        return filter { $0.match(predicateStr: predicate, caseInsensitive: caseInsensitive) }
    }
}

// MARK: - SearchHandler

public class SearchController: NSObject {
    fileprivate let controller: UISearchController

    public init(_ closure: () -> UISearchController) {
        self.controller = closure()
        super.init()
        self.controller.delegate = self
        self.controller.searchResultsUpdater = self
    }

    // MARK: Closures

    private var willAppearClosure: (() -> Void)?
    private var didAppearClosure: (() -> Void)?
    private var willDisappearClosure: (() -> Void)?
    private var didDisappearClosure: (() -> Void)?
    private var updateClosure: ((String) -> Void)?

    // MARK: Configuring

    @discardableResult
    public func onWillAppear(_ closure: @escaping () -> Void) -> SearchController {
        willAppearClosure = closure
        return self
    }

    @discardableResult
    public func onDidAppear(_ closure: @escaping () -> Void) -> SearchController {
        didAppearClosure = closure
        return self
    }

    @discardableResult
    public func onWillDisappear(_ closure: @escaping () -> Void) -> SearchController {
        willDisappearClosure = closure
        return self
    }

    @discardableResult
    public func onDidDisappear(_ closure: @escaping () -> Void) -> SearchController {
        didDisappearClosure = closure
        return self
    }

    @discardableResult
    public func onUpdate(_ closure: @escaping (String) -> Void) -> SearchController {
        updateClosure = closure
        return self
    }

    // Should be called only once.
    @discardableResult
    @nonobjc public  func configure(with tableView: UITableView) -> SearchController {
        let someView = UIView(frame: controller.searchBar.bounds)
        someView.addSubview(controller.searchBar)
        tableView.tableHeaderView = someView
        return self
    }

    @discardableResult
    @nonobjc public func configure(with controller: UITableViewController) -> SearchController {
        // TODO: add search bar
        return self
    }
}

// MARK: - Wrap UISearchControllerDelegate

// TODO: add method presentSearchController(_ :UISearchController)

extension SearchController: UISearchControllerDelegate {

    public func willPresentSearchController(_ searchController: UISearchController) {
        willAppearClosure?()
    }

    public func didPresentSearchController(_ searchController: UISearchController) {
        didAppearClosure?()
    }

    public func willDismissSearchController(_ searchController: UISearchController) {
        willDisappearClosure?()
    }

    public func didDismissSearchController(_ searchController: UISearchController) {
        didDisappearClosure?()
    }
}

// MARK: - Wrap UISearchResultsUpdating

extension SearchController: UISearchResultsUpdating {

    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else { return }
        updateClosure?(searchString)
    }
}

// MARK: - Wrap UISearchController attributes

public extension SearchController {

    var isActive: Bool {
        get { return controller.isActive }
        set { controller.isActive = newValue }
    }
}
