//
//  String+Regexp.swift
//  ToolsFoundation
//
//  Created by Oleg Ketrar on 16.08.2020.
//

import Foundation

extension String {

    /// Validate with `regex`.
    public func validate(regex regStr: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regStr).evaluate(with: self)
    }
}
