//
//  PreloadableContainerView.swift
//  ToolsUIKit
//
//  Created by Oleg Ketrar on 04.12.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

// TODO: rename
// TODO: refactor

/// Use as a container for showing preloader and hiding subviews.
public final class PreloadableContainerView: UIView {

    public enum LoaderType {
        case preloader(UIActivityIndicatorView.Style, UIColor?)
        case customView(UIView)
    }

    private var loaderType: LoaderType = .preloader(.gray, .gray)

    private let container: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.isOpaque = true
        view.isHidden = true

        return view
    }()

    @IBInspectable public var containerColor: UIColor? = nil {
        didSet { container.backgroundColor = containerColor }
    }

    // MARK: - Init

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultConfiguring()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        defaultConfiguring()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        container.frame = bounds
        container.subviews.first?.frame = container.bounds
    }
}

private extension PreloadableContainerView {

    func defaultConfiguring() {
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        container.frame = bounds

        addSubview(container)
        addLoader(type: self.loaderType)
    }

    func addLoader(type: LoaderType) {

        let newLoaderView: UIView = {
            switch type {
            case let .preloader(style, color):
                let preloader = UIActivityIndicatorView(style: style)
                preloader.color = color
                preloader.hidesWhenStopped = true
                preloader.startAnimating()
                return preloader

            case let .customView(loaderView):
                return loaderView
            }
        }()

        newLoaderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newLoaderView.translatesAutoresizingMaskIntoConstraints = true

        container.addSubview(newLoaderView)
    }

    func setContentHidden(_ hidden: Bool, animated: Bool) {
        subviews.filter { $0 !== container }.forEach { view in

            guard animated else {
                view.isHidden = hidden
                return
            }

            UIView.transition(
                with: view,
                duration: 0.15,
                options: [.transitionCrossDissolve, .beginFromCurrentState],
                animations: { view.isHidden = hidden },
                completion: nil)
        }
    }
}

public extension PreloadableContainerView {

    /// Hides subviews and shows animated preloader.
    func setPreloaderHidden(_ hidden: Bool, animated: Bool) {

        if !hidden {
            bringSubviewToFront(container)
        }

        setContentHidden(!hidden, animated: animated)

        guard animated else {
            container.isHidden = hidden
            return
        }

        UIView.transition(
            with: container,
            duration: 0.15,
            options: [.transitionCrossDissolve, .beginFromCurrentState],
            animations: { self.container.isHidden = hidden },
            completion: nil)
    }

    @discardableResult
    func provideLoader(_ newLoaderType: LoaderType) -> Self {

        switch (loaderType, newLoaderType) {
        case let (.preloader, .preloader(newStyle, newColor)):

            if let currentPreloader = container.subviews.first as? UIActivityIndicatorView {
                currentPreloader.style = newStyle
                currentPreloader.color = newColor
            }

        default:
            container.subviews.forEach { $0.removeFromSuperview() }
            addLoader(type: newLoaderType)
        }

        return self
    }

    /// Subviews will be replaced with preloader animated till
    /// `completion` parameter will be called inside `activity` closure.
    /// - parameter activity: Closure means async work. Must call `completion` on end.
    func start(activity: @escaping (@escaping () -> Void) -> Void) {
        setPreloaderHidden(false, animated: false)

        activity { [weak self] in
            self?.setPreloaderHidden(true, animated: true)
        }
    }
}
