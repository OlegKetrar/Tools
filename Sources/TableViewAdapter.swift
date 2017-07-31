//
//  TableViewAdapter.swift
//  Tools
//
//  Created by Oleg Ketrar on 31.07.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import UIKit

/*
class Section<Header, Item, Footer> {
	let header: Header?
	let	footer: Footer?
	let items: [Item] = []

	init(header: Header?, items: [Item], footer: Footer?) {
		self.header = header
		self.footer = footer
		self.items  = items
	}

	subscript(index: Int) -> Item {
		return items[index]
	}
}

final class HeaderSection<Header, Item>: Section<Header, Item, Void> {
	init(header: Header?, items: [Item]) {
		super.init(header: header, items: items, footer: nil)
	}
}

final class ItemSection<Item>: Section<Void, Item, Void> {
	init(items: [Item]) {
		super.init(header: nil, items: items, footer: nil)
	}
}

final class FooterSection<Item, Footer>: Section<Void, Item, Footer> {
	init(items: [Item], footer: Footer?) {
		super.init(header: nil, items: items, footer: footer)
	}
}

final class TableViewAdapter<Data: Equatable, Cell: UITableViewCell, Reusable>: NSObject, UITableViewDataSource, UITableViewDelegate {

//	fileprivate var sectionCountClosure: () -> Int    = { 0 }
//	fileprivate var rowsCountClosure: (Int) -> Int    = { _ in 0 }
//	fileprivate var dataClosure: (IndexPath) -> Data? = { _ in .none }
//	fileprivate var cellClosure: (Cell, Data) -> Void = { _ in }
//
//	fileprivate var shouldSelectClosure: (IndexPath) -> Bool    = { _ in false }
//	fileprivate var selectionClosure: (IndexPath, Cell) -> Void = { _ in }

	private var sections: [Section] = []
	private var cellClosure: (Int, Section)

	// MARK: UITableViewDataSource

	func numberOfSections(in tableView: UITableView) -> Int {
		return sectionCountClosure()
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rowsCountClosure(section)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueCell(for: indexPath) as Cell

		if let data = dataClosure(indexPath) {
			cellClosure(cell, data)
		}
		return cell
	}

	// MARK: UITableViewDelegate

	func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return shouldSelectClosure(indexPath)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

	}
}
*/
