//
//  UIKitExtension.swift
//  ToolsUIKit
//
//  Created by Oleg Ketrar on 10.02.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import ToolsFoundation
import UIKit

// TODO: add docs.

extension UIImage {

    /// Creates image with color with specified size.
    /// - parameter color: fill color.
    /// - parameter size: image size, default 1x1.
    public convenience init?(color: UIColor, size: CGSize = .init(width: 1, height: 1)) {

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

        self.init(
            cgImage: patternImage,
            scale: createdImage.scale,
            orientation: createdImage.imageOrientation)
    }
}

extension UIScreen {

    public var onePixelWidth: CGFloat {
        return 1 / self.scale
    }
    
    public var twoPixelWidth: CGFloat {
        return 2 * onePixelWidth
    }
}

extension UIEdgeInsets {

    public mutating func insetedBy(
        top: CGFloat = 0,
        left: CGFloat = 0,
        bottom: CGFloat = 0,
        right: CGFloat = 0) {

        self.top += top
        self.left += left
        self.bottom += bottom
        self.right += right
    }
}

extension Bundle {

    public static var UIKit: Bundle? {
        return Bundle(identifier: "com.apple.UIKit")
    }
}

extension Array where Element: _SectionType {

    public func item(at indexPath: IndexPath) -> Element.SectionItem? {
        return item(at: indexPath.startIndex)?.item(at: indexPath.row)
    }

    public func absoluteIndex(of indexPath: IndexPath) -> Int {
        let section = indexPath.section - 1

        guard section >= 0 else { return indexPath.row }

        let indexOffset: Int = (0...section).reduce(0) { sum, sectionIndex in
            return sum + self[sectionIndex].items.count
        }

        return indexPath.row + indexOffset
    }
}
