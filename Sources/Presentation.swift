//
//  Presentation.swift
//  ToolsUIKit
//
//  Created by Oleg Ketrar on 11.07.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

/// Encapsulate presenting/pushing and
/// appropriate dismissing/popping view controllers.
public struct Presentation: PresentationType {
    private var wrapped: PresentationType

    private init<T: PresentationType>(wrap presentation: T) {
        wrapped = presentation
    }

    /// - parameter viewController: The view controller to display.
    /// - parameter animated: Pass `true` to animate the presentation; otherwise, pass `false`.
    /// - parameter completion: The block to execute after the presentation finishes.
    @discardableResult
    public func show(
        _ viewController: UIViewController,
        animated: Bool = true,
        completion: @escaping () -> Void = {}) -> Bool {

        return wrapped.show(viewController, animated: animated, completion: completion)
    }

    /// - parameter animated: Pass `true` to animate the presentation; otherwise, pass `false`.
    /// - parameter completion: The block to execute after the presentation finishes.
    @discardableResult
    public func hide(animated: Bool = true, completion: @escaping () -> Void = {}) -> Bool {
        return wrapped.hide(animated: animated, completion: completion)
    }
}

public extension Presentation {

    /// Creates presentation which presents modally over specified `viewController`.
    /// - parameter viewController: Parent view controller.
    static func present(
        over viewController: UIViewController,
        inside navigationController: UINavigationController? = nil) -> Presentation {

        return Presentation(wrap: ModalPresentaton(
            over: viewController,
            inside: navigationController))
    }

    /// Creates presentation which push view controller into specified `navigationController`.
    /// - parameter navigationController: Navigation controller.
    static func push(into navigationController: UINavigationController) -> Presentation {
        return Presentation(wrap: PushPresentaton(into: navigationController))
    }
}

// MARK: -

/// Internal Presentation interface.
private protocol PresentationType {

    func show(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void) -> Bool

    func hide(animated: Bool, completion: @escaping () -> Void) -> Bool
}

// MARK: -

/// Modal presentation.
/// Represents present/dismiss.
private final class ModalPresentaton: PresentationType {
    private var navigationController: UINavigationController?
    private weak var parentViewController: UIViewController?

    init(over viewController: UIViewController, inside nc: UINavigationController?) {
        parentViewController = viewController
    }

    func show(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void) -> Bool {

        guard let parentVC = parentViewController else { return false }

        let presentedVC: UIViewController = {
            guard let nc = navigationController else { return viewController }

            nc.setViewControllers([viewController], animated: false)
            return nc
        }()

        navigationController = nil

        parentVC.present(presentedVC, animated: animated, completion: completion)
        return true
    }

    func hide(animated: Bool, completion: @escaping () -> Void) -> Bool {

        if let presentedVC = parentViewController?.presentedViewController {
            presentedVC.dismiss(animated: animated, completion: completion)
            return true
        } else {
            return false
        }
    }
}

// MARK: -

/// PushPresentaton.
/// Represents push/pop inside navigation controller.
private final class PushPresentaton: PresentationType {

    private weak var startedViewController: UIViewController?
    private weak var navigationController: UINavigationController?

    init(into navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func show(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void) -> Bool {

        guard let nc = navigationController,
            let currentVC = nc.topViewController else { completion(); return false }

        startedViewController = currentVC
        nc.push(viewController, animated: animated, completion: completion)

        return true
    }

    func hide(animated: Bool, completion: @escaping () -> Void) -> Bool {

        guard let vc = startedViewController,
            let nc = navigationController else { completion(); return true }

        nc.pop(to: vc, animated: animated, completion: completion)

        return true
    }
}

/// Convenience Push/Pop with completion closure.
private extension UINavigationController {

    func push(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void) {

        pushViewController(viewController, animated: animated)

        guard animated, let coordinator = transitionCoordinator else {
            completion()
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }

    func pop(
        to viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void) {

        popToViewController(viewController, animated: animated)

        guard animated, let coordinator = transitionCoordinator else {
            completion()
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}
