//
//  Section.swift
//  ToolsFoundation
//
//  Created by Oleg Ketrar on 27/03/2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

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

public struct Section<Info, Item>: _SectionType {
    public var info: Info
    public var items: [Item]

    public init(info: Info, items: [Item] = []) {
        self.info = info
        self.items = items
    }
}

public extension Array where Element: _SectionType {

    func info(forSectionAt index: Int) -> Element.SectionInfo? {
        return item(at: index)?.info
    }
}
