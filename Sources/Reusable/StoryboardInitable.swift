//
//  StoryboardInitable.swift
//  Reusable
//
//  Created by Oleg Ketrar on 06.08.2020.
//

import Foundation
import UIKit

public protocol StoryboardInitable: Reusable {
    associatedtype StoryboardIdentifier: RawRepresentable

    static var storyboard: StoryboardIdentifier { get }

    /// Storyboard bundle, current bundle used by default.
    static var storyboardBundle: Bundle? { get }
}

public extension StoryboardInitable {
    static var storyboardBundle: Bundle? { nil }
}

public extension StoryboardInitable where Self: UIViewController,
    StoryboardIdentifier.RawValue == String {

    /// Instantiate view controller from appropriate storyboard.
    /// View controller Storyboard ID must be the same
    /// as a view controller class name.
    static func instantiateViaStoryboard() -> Self {

        let sb = UIStoryboard(
            name: storyboard.rawValue,
            bundle: storyboardBundle)

        return sb.instantiateViewController() as Self
    }
}
