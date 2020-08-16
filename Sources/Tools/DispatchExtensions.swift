//
//  DispatchExtensions.swift
//  Tools
//
//  Created by Oleg Ketrar on 15.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import Dispatch

/// Call `closure` after `seconds` on `main` queue.
public func withDelay(
    _ seconds: TimeInterval,
    _ closure: @escaping () -> Void) {

    DispatchQueue.main.asyncAfter(
        deadline: .now() + .milliseconds(Int(seconds * 1000)),
        execute: closure)
}

/// Call `closure` after standart time of animation (0.33 seconds).
/// Closure will be called on `main` queue.
public func withAnimationDelay(_ closure: @escaping () -> Void) {
    withDelay(0.33, closure)
}
