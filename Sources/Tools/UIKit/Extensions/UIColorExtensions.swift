//
//  UIColorExtensions.swift
//  ToolsUIKit
//
//  Created by Oleg Ketrar on 23/12/2018.
//  Copyright © 2018 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    public convenience init(red: Int, green: Int, blue: Int) {

        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(
            red: CGFloat(red) / CGFloat(255.0),
            green: CGFloat(green) / CGFloat(255.0),
            blue: CGFloat(blue) / CGFloat(255.0),
            alpha: 1.0)
    }

    public convenience init(hexColor: Int) {
        self.init(
            red: (hexColor >> 16) & 0xff,
            green: (hexColor >> 8) & 0xff,
            blue: hexColor & 0xff)
    }

    public convenience init?(hexString: String) {
        guard let int = Int(hexString, radix: 16) else { return nil }
        self.init(hexColor: int)
    }

    public var hexCode: Int {
        let coreImageColor = CIColor(color: self)

        let r = Int(coreImageColor.red * 255 + 0.5)
        let g = Int(coreImageColor.green * 255 + 0.5)
        let b = Int(coreImageColor.blue * 255 + 0.5)

        return (r << 16) | (g << 8) | b
    }

    public var hexString: String {
        return String(hexCode, radix: 16, uppercase: true)
    }

    // FIXME: rename

    /// Producing new color as a result of
    /// rendering `self` with `alpha` on background `bgColor`.
    public func with(alpha: CGFloat, on bgColor: UIColor) -> UIColor {
        return bgColor.add(overlay: self.withAlphaComponent(alpha))
    }

    // FIXME: rename

    public func add(overlay: UIColor) -> UIColor {
        var bgR: CGFloat = 0
        var bgG: CGFloat = 0
        var bgB: CGFloat = 0
        var bgA: CGFloat = 0

        var fgR: CGFloat = 0
        var fgG: CGFloat = 0
        var fgB: CGFloat = 0
        var fgA: CGFloat = 0

        self.getRed(&bgR, green: &bgG, blue: &bgB, alpha: &bgA)
        overlay.getRed(&fgR, green: &fgG, blue: &fgB, alpha: &fgA)

        let r = fgA * fgR + (1 - fgA) * bgR
        let g = fgA * fgG + (1 - fgA) * bgG
        let b = fgA * fgB + (1 - fgA) * bgB

        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
