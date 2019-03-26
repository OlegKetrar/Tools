//
//  UIView+RoundedCorners.swift
//  Tools
//
//  Created by Oleg Ketrar on 27/03/2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {

    func round(
        corners: UIRectCorner = [.allCorners],
        radius radiusOrNil: CGFloat? = nil) {

        let radius = radiusOrNil ?? 0.5 * min(bounds.width, bounds.height)

        if #available(iOS 11, *) {
            layer.cornerRadius = radius
            layer.maskedCorners = radius > 0 ? corners.cornerMask : []
            layer.masksToBounds = radius > 0
        } else {
            layer.mask          = mask(by: corners, radius: radius)
            layer.masksToBounds = layer.mask != nil
        }
    }

    func removeRoundedCorners() {
        round(radius: 0)
    }
}

// MARK: - Private

private extension UIView {

    func mask(
        by roundingCorners: UIRectCorner,
        radius: CGFloat) -> CAShapeLayer? {

        guard radius != 0 else { return nil }

        let maskLayer  = CAShapeLayer()
        maskLayer.path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: roundingCorners,
            cornerRadii: CGSize(width: radius, height: radius)).cgPath

        maskLayer.fillColor       = UIColor.black.cgColor
        maskLayer.backgroundColor = UIColor.white.cgColor

        return maskLayer
    }
}

private extension UIRectCorner {

    var cornerMask: CACornerMask {
        var mask: CACornerMask = []

        if contains(.topLeft) {
            mask.insert(.layerMinXMinYCorner)
        }

        if contains(.topRight) {
            mask.insert(.layerMaxXMinYCorner)
        }

        if contains(.bottomLeft) {
            mask.insert(.layerMinXMaxYCorner)
        }

        if contains(.bottomRight) {
            mask.insert(.layerMaxXMaxYCorner)
        }

        return mask
    }
}
