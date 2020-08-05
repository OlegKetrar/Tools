//
//  UIStoryboard+Reusable.swift
//  Reusable
//
//  Created by Oleg Ketrar on 06.08.2020.
//

import UIKit

public extension UIStoryboard {

    /// Instantiate appropriate view controller.
    /// View controller `StoryboardID` must match `reuseIdentifier`.
    func instantiateViewController<T: UIViewController>() -> T where T: Reusable {

        let vcOrNil = instantiateViewController(
            withIdentifier: T.reuseIdentifier) as? T

        guard let vc = vcOrNil else {
            fatalError("""
                Can't instantiate view controller \(T.self) \
                with identifier \(T.reuseIdentifier)
                """)
        }

        return vc
    }
}
