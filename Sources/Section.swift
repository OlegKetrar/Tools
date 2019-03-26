//
//  Section.swift
//  Tools
//
//  Created by Oleg Ketrar on 27/03/2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

public struct Section<Info, Item> {
    public var info: Info
    public var items: [Item]

    public init(info: Info, items: [Item] = []) {
        self.info  = info
        self.items = items
    }
}

// MARK: Array Section conveniences

public protocol _SectionType {
    associatedtype SectionInfo
    associatedtype SectionItem

    var info: SectionInfo { get }
    var items: [SectionItem] { get }
}

public extension _SectionType {

    func item(at index: Int) -> SectionItem? {
        return items.item(at: index)
    }
}

extension Section: _SectionType {}

public extension Array where Element: _SectionType {

    func item(at indexPath: IndexPath) -> Element.SectionItem? {
        return item(at: indexPath.section)?.item(at: indexPath.row)
    }

    func info(forSectionAt index: Int) -> Element.SectionInfo? {
        return item(at: index)?.info
    }

    func absoluteIndex(of indexPath: IndexPath) -> Int {
        let section = indexPath.section - 1

        guard section >= 0 else { return indexPath.row }

        let indexOffset: Int = (0...section).reduce(0) { sum, sectionIndex in
            return sum + self[sectionIndex].items.count
        }

        return indexPath.row + indexOffset
    }
}
