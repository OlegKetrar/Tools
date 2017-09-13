//
//  Presentation.swift
//  Tools
//
//  Created by Oleg Ketrar on 11.07.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import UIKit
import AlertDispatcher

// TODO: refactor to use protocol and structures

public enum Presentation {
    case push(into: UINavigationController)
    case present(on: UIViewController)
    case presentOnTop
    // TODO: custom animators

    /// vc to present & should animate
    public var present: (UIViewController, Bool) -> Void {
        switch self {
        case let .push(into: nc):
            return { [weak nc] in nc?.pushViewController($0, animated: $1) }

        case let .present(on: vc):
            return { [weak vc] in vc?.present($0, animated: $1, completion: nil) }

        case .presentOnTop:
            return { Alert.topViewController.present($0, animated: $1, completion: nil) }
        }
    }

    /// animated
    public var dismiss: (Bool) -> Void {
        switch self {
        case let .push(into: nc):
            return { [weak nc] in _ = nc?.popViewController(animated: $0) }

        case let .present(on: vc):
            return { [weak vc] in vc?.presentedViewController?.dismiss(animated: $0, completion: nil) }

        case .presentOnTop:
            return { Alert.topViewController.dismiss(animated: $0, completion: nil) }
        }
    }
}
