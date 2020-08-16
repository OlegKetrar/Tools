//
//  Section.swift
//  ToolsFoundation
//
//  Created by Oleg Ketrar on 27/03/2019.
//

/// Private protocol.
public protocol _SectionType {
    associatedtype SectionInfo
    associatedtype SectionItem

    var info: SectionInfo { get }
    var items: [SectionItem] { get }
}

extension _SectionType {

    public func item(at index: Int) -> SectionItem? {
        return items.item(at: index)
    }
}

/// Array of `items` with shared `info`.
public struct Section<Info, Item>: _SectionType {
    public var info: Info
    public var items: [Item]

    public init(info: Info, items: [Item] = []) {
        self.info = info
        self.items = items
    }
}

extension Section: Equatable where Info: Equatable, Item: Equatable {

    public static func ==(lfs: Section, rhs: Section) -> Bool {
        return lfs.info == rhs.info && lfs.items == rhs.items
    }
}

/// Collections of items with shared `name`.
public typealias NamedSection<T> = Section<String, T>

extension Section where Info == String {

    /// Shared name of section.
    public var name: String { info }
}

extension Collection where Element: _SectionType, Index == Int {

    /// Get `info` of a single section at `index`.
    public func info(forSectionAt index: Int) -> Element.SectionInfo? {
        return item(at: index)?.info
    }
}
