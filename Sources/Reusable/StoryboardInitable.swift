//
//  StoryboardInitable.swift
//  Reusable
//
//  Created by Oleg Ketrar on 06.08.2020.
//

import Foundation
import UIKit

/// Type which represents
public protocol StoryboardIdentifier {
    var filename: String { get }
}

public protocol StoryboardInitable: Reusable {
    associatedtype Storyboard: StoryboardIdentifier

    static var storyboard: Storyboard { get }

    /// Storyboard bundle, current bundle used by default.
    static var storyboardBundle: Bundle? { get }
}

public extension StoryboardInitable {
    static var storyboardBundle: Bundle? { nil }
}

public extension StoryboardInitable where Self: UIViewController {

    /// Instantiate view controller from appropriate storyboard.
    /// View controller Storyboard ID must be the same
    /// as a view controller class name.
    static func instantiateViaStoryboard() -> Self {
        UIStoryboard
            .init(name: storyboard.filename, bundle: storyboardBundle)
            .instantiateViewController()
    }
}
