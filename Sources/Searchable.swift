//
//  Searchable.swift
//  Tools
//
//  Created by Oleg Ketrar on 10.02.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Searchable (entities)

public protocol Searchable {
	var searchTags: [String] { get }
	func match(predicateStr: String, caseInsensitive: Bool) -> Bool
}

public extension Searchable {
	public func match(predicateStr: String, caseInsensitive: Bool = true) -> Bool {
		guard !predicateStr.isEmpty else { return true }
		let whithoutWhitespaces = predicateStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		
		if caseInsensitive {
			return searchTags.filter { $0.lowercased().contains(whithoutWhitespaces.lowercased()) }.count > 0
		} else {
			return searchTags.filter { $0.contains(whithoutWhitespaces) }.count > 0
		}
	}
}

// MARK: - Convenience for searchable entity collection

public extension Array where Element: Searchable {
	public func match(predicate: String, caseInsensitive: Bool = true) -> Array {
		return filter { $0.match(predicateStr: predicate, caseInsensitive: caseInsensitive) }
	}
}

// MARK: - SearchHandler

public class SearchHandler: NSObject {
	
	fileprivate let searchController: UISearchController

	public init(_ closure: () -> UISearchController) {
		self.searchController = closure()
		super.init()
		self.searchController.delegate = self
		self.searchController.searchResultsUpdater = self
	}
	
	// MARK: Closures
	
	fileprivate var willAppearClosure:    (() -> Void)?
	fileprivate var didAppearClosure:     (() -> Void)?
	fileprivate var willDisappearClosure: (() -> Void)?
	fileprivate var didDisappearClosure:  (() -> Void)?
	fileprivate var updateClosure:        ((String) -> Void)?
	
	// MARK: Configuring
	
	@discardableResult
	public func onWillAppear(_ closure: @escaping () -> Void) -> SearchHandler {
		willAppearClosure = closure
		return self
	}
	
	@discardableResult
	public func onDidAppear(_ closure: @escaping () -> Void) -> SearchHandler {
		didAppearClosure = closure
		return self
	}
	
	@discardableResult
	public func onWillDisappear(_ closure: @escaping () -> Void) -> SearchHandler {
		willDisappearClosure = closure
		return self
	}
	
	@discardableResult
	public func onDidDisappear(_ closure: @escaping () -> Void) -> SearchHandler {
		didDisappearClosure = closure
		return self
	}
	
	@discardableResult
	public func onUpdate(_ closure: @escaping (String) -> Void) -> SearchHandler {
		updateClosure = closure
		return self
	}
	
	// will be called only once
	
	@discardableResult
	@nonobjc public  func configure(with tableView: UITableView) -> SearchHandler {
		let someView = UIView(frame: searchController.searchBar.bounds)
		someView.addSubview(searchController.searchBar)
		tableView.tableHeaderView = someView
		return self
	}
	
	@discardableResult
	@nonobjc public func configure(with controller: UITableViewController) -> SearchHandler {
		// TODO: add search bar
		return self
	}
}

// MARK: - Wrap UISearchControllerDelegate
// TODO: - add method presentSearchController(_ :UISearchController)

extension SearchHandler: UISearchControllerDelegate {
	public func willPresentSearchController(_ searchController: UISearchController) { willAppearClosure?()    }
	public func didPresentSearchController(_ searchController: UISearchController)  { didAppearClosure?()     }
	public func willDismissSearchController(_ searchController: UISearchController) { willDisappearClosure?() }
	public func didDismissSearchController(_ searchController: UISearchController)  { didDisappearClosure?()  }
}

// MARK: - Wrap UISearchResultsUpdating

extension SearchHandler: UISearchResultsUpdating {
	public func updateSearchResults(for searchController: UISearchController) {
		guard let searchString = searchController.searchBar.text else { return }
		updateClosure?(searchString)
	}
}

// MARK: - Wrap UISearchController attributes

extension SearchHandler {
	public var isActive: Bool {
		get { return searchController.isActive }
		set { searchController.isActive = newValue }
	}
}

// MARK: - Realm support

/*
@objc protocol SearchableRealmType {
	var searchTags: String { get }
}

extension Results where T: SearchableRealmType {
	func match(searchStr: String, caseInsensitive: Bool = true) -> Results {
		
		// remove punctuations & whitespaces
		let disallowedChars = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
		let predicateStr    = searchStr.trimmingCharacters(in: disallowedChars)
		
		// validate search str
		guard !predicateStr.isEmpty else { return self }
		
		// form predicate
		let searchPredicate = NSComparisonPredicate(leftExpression: NSExpression(forKeyPath: #keyPath(SearchableRealmType.searchTags)),
		                                            rightExpression: NSExpression(forConstantValue: predicateStr),
		                                            modifier: .direct,
		                                            type: .contains,
		                                            options: caseInsensitive ? [.caseInsensitive] : [])
		// search
		return self.filter(searchPredicate)
	}
}
*/
