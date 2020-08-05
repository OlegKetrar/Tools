//
//  HasApply.swift
//  ToolsFoundation
//
//  Created by Oleg Ketrar on 27/03/2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

public protocol HasApply {}

public extension HasApply {

    /// Used for Value types.
    func with(_ closure: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try closure(&copy)
        return copy
    }

    func `do`(_ closure: (Self) throws -> Void) rethrows {
        try closure(self)
    }
}

public extension HasApply where Self: AnyObject {

    /// Used for Reference types.
    func apply(_ closure: (Self) throws -> Void) rethrows -> Self {
        try closure(self)
        return self
    }
}
