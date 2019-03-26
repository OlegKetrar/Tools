//
//  UIKitExtension.swift
//  Tools
//
//  Created by Oleg Ketrar on 10.02.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import UIKit

// TODO: add docs.

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / CGFloat(255.0),
                  green: CGFloat(green) / CGFloat(255.0),
                  blue: CGFloat(blue) / CGFloat(255.0),
                  alpha: 1.0)
    }
    
    convenience init(hexColor: Int) {
        self.init(
            red: (hexColor >> 16) & 0xff,
            green: (hexColor >> 8) & 0xff,
            blue: hexColor & 0xff)
    }
    
    func hexCode() -> Int {
        let coreImageColor = CIColor(color: self)

        let r = Int(coreImageColor.red * 255 + 0.5)
        let g = Int(coreImageColor.green * 255 + 0.5)
        let b = Int(coreImageColor.blue * 255 + 0.5)

        return (r << 16) | (g << 8) | b
    }
}

// MARK: Color detection

public extension UIImage {

    /// Creates image with color with specified size.
    /// - parameter color: fill color.
    /// - parameter size: image size, default 1x1.
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let image: UIImage? = {
            defer { UIGraphicsEndImageContext() }

            let rect = CGRect(origin: .zero, size: size)

            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
            color.setFill()
            UIRectFill(rect)

            return UIGraphicsGetImageFromCurrentImageContext()
        }()

        guard let createdImage = image,
            let patternImage = createdImage.cgImage else { return nil }

        self.init(cgImage: patternImage, scale: createdImage.scale, orientation: createdImage.imageOrientation)
    }
}

public extension UIScreen {
    var onePixelWidth: CGFloat {
        return 1 / self.scale
    }
    
    var twoPixelWidth: CGFloat {
        return 2 * onePixelWidth
    }
}

public extension CGRect {
    func expanded(by offset: CGFloat) -> CGRect {
        return CGRect(
            x: origin.x - offset,
            y: origin.y - offset,
            width: size.width + 2 * offset,
            height: size.height + 2 * offset)
    }
}

public extension UIEdgeInsets {
    mutating func insetedBy(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        self.top    += top
        self.left   += left
        self.bottom += bottom
        self.right  += right
    }
}

// MARK: - UIView + AutoLayout

public extension UIView {

    @discardableResult
    func addPinConstraint(
        toSubview subview: UIView,
        attribute: NSLayoutAttribute,
        withSpacing spacing: CGFloat) -> NSLayoutConstraint {

        subview.translatesAutoresizingMaskIntoConstraints = false

        let constraint = NSLayoutConstraint(
            item: subview,
            attribute: attribute,
            relatedBy: .equal,
            toItem: self,
            attribute: attribute,
            multiplier: 1.0,
            constant: spacing)

        addConstraint(constraint)
        return constraint
    }

    @discardableResult
    func addPinConstraints(toSubview subview: UIView, withSpacing spacing: CGFloat = 0.0) -> [NSLayoutConstraint] {
        return [
            addPinConstraint(toSubview: subview, attribute: .left, withSpacing: spacing),
            addPinConstraint(toSubview: subview, attribute: .top, withSpacing: spacing),
            addPinConstraint(toSubview: subview, attribute: .right, withSpacing: -spacing),
            addPinConstraint(toSubview: subview, attribute: .bottom, withSpacing: -spacing)
        ]
    }

    func addPinnedSubview(_ subview: UIView, withSpacing spacing: CGFloat = 0.0) {
        addSubview(subview)
        translatesAutoresizingMaskIntoConstraints = false
        addPinConstraints(toSubview: subview, withSpacing: spacing)
    }

    func addPinnedSubview(_ subview: UIView, withInsets insets: UIEdgeInsets) {
        addSubview(subview)
        translatesAutoresizingMaskIntoConstraints = false
        subview.pinToSuperview(insets: insets)
    }

    @discardableResult
    func pinToSuperview(attribute: NSLayoutAttribute, spacing: CGFloat = 0) -> NSLayoutConstraint? {
        return superview?.addPinConstraint(toSubview: self, attribute: attribute, withSpacing: spacing)
    }

    @discardableResult
    func pinToSuperview(insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        return [
            pinToSuperview(attribute: .left, spacing: insets.left),
            pinToSuperview(attribute: .top, spacing: insets.top),
            pinToSuperview(attribute: .right, spacing: -insets.right),
            pinToSuperview(attribute: .bottom, spacing: -insets.bottom)
        ].compactMap { $0 }
    }
}
