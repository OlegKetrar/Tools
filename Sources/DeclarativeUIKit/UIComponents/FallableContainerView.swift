//
//  FallableContainerView.swift
//  Tools
//
//  Created by Oleg Ketrar on 26/02/2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

// TODO: rename
// TODO: error register mechanism

public final class FallibleContainerView: UIView {
    private var commonErrorView: UIView?
    private var errorViews: [String : UIView] = [:]

    private let errorContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Overrides

    override public init(frame: CGRect) {
        super.init(frame: frame)
        defaultConfiguring()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultConfiguring()
    }

    // MARK: - Public

    public func registerError(identifier: String, toView view: UIView) {
        errorViews[identifier] = view
    }

    public func registerCommonErrorView(_ view: UIView) {
        commonErrorView = view
    }

    public func showError(identifier: String) {
        guard let appropriateView = errorViews[identifier] ?? commonErrorView else {
            fatalError("no errorView register")
        }

        showErrorView(appropriateView)
    }

    public func showCommonError() {
        guard let appropriateView = commonErrorView else {
            fatalError("no errorView register")
        }

        showErrorView(appropriateView)
    }

    public func showContent() {
        errorContainer.isHidden = true
    }

    deinit {
        commonErrorView?.removeFromSuperview()
        errorViews.values.forEach { $0.removeFromSuperview() }
    }
}

// MARK: - Private

private extension FallibleContainerView {

    func showErrorView(_ errorView: UIView) {
        errorContainer.subviews.forEach { $0.removeFromSuperview() }
        errorContainer.addPinnedSubview(errorView)
        errorContainer.isHidden = false
    }

    func defaultConfiguring() {
        addPinnedSubview(errorContainer)

        bringSubviewToFront(errorContainer)
        showContent()
    }
}
