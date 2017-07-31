//
//  Button.swift
//  Tools
//
//  Created by Oleg Ketrar on 04.07.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

/// `Button` with animated preloader.
/// Use to notify about performing async work.
/// `Button` use `disabled` state to show preloader, do not set any parameters to `disabled` state
public final class Button: UIButton {
	fileprivate lazy var preloader: UIActivityIndicatorView = {
		let indicator   = UIActivityIndicatorView(activityIndicatorStyle: .white)
		indicator.color = self.preloaderColor
		indicator.frame = .zero
		indicator.hidesWhenStopped = true

		return indicator
	}()

	@IBInspectable
	public var preloaderColor: UIColor = UIColor.white {
		didSet { preloader.color = preloaderColor }
	}

	/// Should set hide button image in preloaded state.
	/// Default `true`.
	public var shouldAffectImage: Bool = true

	// MARK: - Init

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

		if let normalImage = image(for: .normal), image(for: .disabled) == normalImage, shouldAffectImage {
			setImage(UIImage(color: .clear, size: normalImage.size), for: .disabled)
		}
	}

	deinit {
		preloader.removeFromSuperview()
	}

	// MARK: - Lifecycle

	override public func layoutSubviews() {
		super.layoutSubviews()

		preloader.sizeToFit()
		preloader.frame = CGRect(
			x: 0.5 * (bounds.width - preloader.bounds.width),
			y: 0.5 * (bounds.height - preloader.bounds.height),
			width: preloader.bounds.width,
			height: preloader.bounds.height)
	}

	// MARK: - Control

	/// Show animated preloader instead of button title.
	public func startPreloader(_ start: Bool = true) {
		guard isEnabled == start else { return }

		if start {
			preloader.startAnimating()
			isEnabled = false
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
		activity { [weak self] in self?.stopPreloader() }
	}
}
