//
//  Button.swift
//  ToolsUIKit
//
//  Created by Oleg Ketrar on 04.07.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

// TODO: refactor

/// `Button` with animated preloader.
/// Use to notify about performing async work.
/// `Button` use `disabled` state to show preloader, do not set any parameters to `disabled` state
@objc(ToolsButton)
public final class Button: UIButton {

    private lazy var preloader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.color = self.preloaderColor
        indicator.frame = .zero
        indicator.hidesWhenStopped = true

        return indicator
    }()

    @IBInspectable
    public var preloaderColor: UIColor = UIColor.white {
        didSet { preloader.color = preloaderColor }
    }

    /// Should hide button image while preloader active.
    /// Default `true`.
    public var shouldAffectImage: Bool = true

    override public init(frame: CGRect) {
        super.init(frame: frame)
        defaultConfiguring()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultConfiguring()
    }

    private func defaultConfiguring() {
        addSubview(preloader)
        setAttributedTitle(NSAttributedString(string: "", attributes: nil), for: .disabled)
        setTitle("", for: .disabled)
    }

    deinit {
        preloader.removeFromSuperview()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        preloader.sizeToFit()
        preloader.frame = CGRect(
            x: 0.5 * (bounds.width - preloader.bounds.width),
            y: 0.5 * (bounds.height - preloader.bounds.height),
            width: preloader.bounds.width,
            height: preloader.bounds.height)
    }

    /// Show animated preloader instead of button title.
    public func startPreloader(_ start: Bool = true) {
        guard isEnabled == start else { return }

        if start {
            if shouldAffectImage,
                let normalImage = image(for: .normal) {

                setImage(UIImage(color: .clear, size: normalImage.size), for: .disabled)
            }

            preloader.startAnimating()
            isEnabled = false
            isSelected = false
        } else {
            preloader.stopAnimating()
            isEnabled = true
        }
    }

    /// Hide preloader and show normal button title.
    public func stopPreloader() {
        startPreloader(false)
    }

    /// Do async work with preloader.
    /// - parameter activity: Work closure to be executed (must call closure parameter when finished).
    /// ```
    /// let button = Button.init(frame: .zero)
    /// button.start(activity: { (onCompletion) in
    ///     // do some async work
    ///
    ///     // call when work completed
    ///     onCompletion()
    /// })
    /// ```
    public func start(activity: @escaping (@escaping () -> Void) -> Void) {
        startPreloader()
        activity { [weak self] in
            DispatchQueue.main.async { self?.stopPreloader() }
        }
    }
}
