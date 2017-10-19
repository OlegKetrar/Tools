//
//  Presentation.swift
//  Tools
//
//  Created by Oleg Ketrar on 11.07.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import UIKit
import AlertDispatcher

/// Encapsulate presenting/pushing and
/// appropriate dismissing/popping view controllers.
public struct Presentation: PresentationType {

    private var wrapped: PresentationType
    private init<T: PresentationType>(wrap presentation: T) { wrapped = presentation }

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

extension Presentation {

    /// Creates presentation which presents modally over specified `viewController`.
    /// - parameter viewController: Parent view controller.
    public static func present(over viewController: UIViewController) -> Presentation {
        return Presentation(wrap: ModalPresentaton(over: viewController))
    }

    /// Creates presentation which presents modally over currently topmost view controller.
    public static func presentOverTop() -> Presentation {
        return Presentation(wrap: ModalPresentaton(over: Alert.topViewController))
    }

    /// Creates presentation which push view controller into specified `navigationController`.
    /// - parameter navigationController: Navigation controller.
    public static func push(into navigationController: UINavigationController) -> Presentation {
        return Presentation(wrap: PushPresentaton(into: navigationController))
    }
}

/// Internal Presentation interface.
private protocol PresentationType {
    func show(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) -> Bool
    func hide(animated: Bool, completion: @escaping () -> Void) -> Bool
}

/// Modal presentation.
/// Represents present/dismiss.
private struct ModalPresentaton: PresentationType {
    private weak var parentViewController: UIViewController?

    init(over viewController: UIViewController) {
        parentViewController = viewController
    }

    func show(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) -> Bool {
        guard let parentVC = parentViewController else { return false }

        parentVC.present(viewController, animated: animated, completion: completion)
        return true
    }

    func hide(animated: Bool, completion: @escaping () -> Void) -> Bool {
        guard let presentedVC = parentViewController?.presentedViewController else { return false }

        presentedVC.dismiss(animated: animated, completion: completion)
        return true
    }
}

/// PushPresentaton.
/// Represents push/pop inside navigation controller.
private final class PushPresentaton: PresentationType {

    private weak var pushedViewController: UIViewController?
    private weak var navigationController: UINavigationController?

    init(into navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func show(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) -> Bool {
        guard let nc = navigationController else { return false }

        pushedViewController = viewController
        nc.push(viewController, animated: animated, completion: completion)
        return true
    }

    func hide(animated: Bool, completion: @escaping () -> Void) -> Bool {
        guard let vc = pushedViewController,
            let nc = navigationController else { return true }

        nc.pop(to: vc, animated: animated, completion: completion)
        return true
    }
}

/// Convenience Push/Pop with completion closure.
private extension UINavigationController {
    func push(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)

        guard animated, let coordinator = transitionCoordinator else {
            completion()
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }

    func pop(to viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        popToViewController(viewController, animated: animated)

        guard animated, let coordinator = transitionCoordinator else {
            completion()
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}
