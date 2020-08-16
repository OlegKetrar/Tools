//
//  HasApply.swift
//  ToolsFoundation
//
//  Created by Oleg Ketrar on 27/03/2019.
//

public protocol HasApply {}

extension HasApply {

    /// Used for Value types.
    public func with(_ closure: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try closure(&copy)
        return copy
    }

    public func `do`(_ closure: (Self) throws -> Void) rethrows {
        try closure(self)
    }
}

extension HasApply where Self: AnyObject {

    /// Used for Reference types.
    public func apply(_ closure: (Self) throws -> Void) rethrows -> Self {
        try closure(self)
        return self
    }
}
