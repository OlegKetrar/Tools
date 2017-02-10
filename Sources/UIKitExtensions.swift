//
//  UIKitExtension.swift
//  Tools
//
//  Created by Oleg Ketrar on 2/10/17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import UIKit

extension UIColor {
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
        self.init(red: (hexColor >> 16) & 0xff, green: (hexColor >> 8) & 0xff, blue: hexColor & 0xff)
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

extension UIColor {
    func isLight() -> Bool {
		
		let coreImageColor = CIColor(color: self)
        let red   = coreImageColor.red
        let green = coreImageColor.green
        let blue  = coreImageColor.blue

		let brightness = ( (red * 299) + (green * 587) + (blue * 112) ) / 1000
		return !(brightness < 0.5)
    }
	
    func appropriateTopColor() -> UIColor {
        
        if self.isLight() {
            return UIColor.darkText
        }
        else {
            return UIColor.white
        }
    }
    
    func appropiateBorderColor() -> UIColor {
        return appropriateTopColor().withAlphaComponent(0.15)
    }
	
	func appropriateStatusBarStyle() -> UIStatusBarStyle {
		return isLight() ? .default : .lightContent
	}
}

extension UIImage {
    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
		
		if let patternImage = image?.cgImage {
			self.init(cgImage: patternImage)
		}
		else {
			fatalError("")
		}
    }
	
	func averageColor() -> UIColor {
		let rgba       = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let info       = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		let context    = CGContext(data: rgba, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: info.rawValue)
		
		context?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
		
		if rgba[3] > 0 {
			let alpha: CGFloat = CGFloat(rgba[3]) / 255.0
			let multiplier: CGFloat = alpha / 255.0
			
			return UIColor(red: CGFloat(rgba[0]) * multiplier,
			               green: CGFloat(rgba[1]) * multiplier,
			               blue: CGFloat(rgba[2]) * multiplier,
			               alpha: alpha)
		}
		else {
			return UIColor(red: CGFloat(rgba[0]) / 255.0,
			               green: CGFloat(rgba[1]) / 255.0,
			               blue: CGFloat(rgba[2]) / 255.0,
			               alpha: CGFloat(rgba[3]) / 255.0)
		}
	}
}

extension UIScreen {
    var onePixelWidth: CGFloat {
        return 1.0 / self.scale
    }
    
    var twoPixelWidth: CGFloat {
        return 2 * onePixelWidth
    }
}

// MARK: - UIView + AutoLayout

extension UIView {

    @discardableResult
    func addPinConstraint(toSubview subview: UIView,
                          attribute: NSLayoutAttribute,
                          withSpacing spacing: CGFloat) -> NSLayoutConstraint {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: subview, attribute: attribute, relatedBy: .equal,
                                            toItem: self, attribute: attribute, multiplier: 1.0, constant: spacing)
        addConstraint(constraint)

        return constraint
    }

    @discardableResult
    func addPinConstraints(toSubview subview: UIView, withSpacing spacing: CGFloat = 0.0) -> [NSLayoutConstraint] {
        return [ addPinConstraint(toSubview: subview, attribute: .left, withSpacing: spacing),
                 addPinConstraint(toSubview: subview, attribute: .top, withSpacing: spacing),
                 addPinConstraint(toSubview: subview, attribute: .right, withSpacing: -spacing),
                 addPinConstraint(toSubview: subview, attribute: .bottom, withSpacing: -spacing) ]
    }
    
    func addPinnedSubview(_ subview: UIView, withSpacing spacing: CGFloat = 0.0) {
        addSubview(subview)
        translatesAutoresizingMaskIntoConstraints = false
        addPinConstraints(toSubview: subview, withSpacing: spacing)
    }

    @discardableResult
    func pinToSuperview(attribute: NSLayoutAttribute, spacing: CGFloat = 0) -> NSLayoutConstraint? {
        return superview?.addPinConstraint(toSubview: self, attribute: attribute, withSpacing: spacing)
    }

    @discardableResult
    func pinToSuperview(insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        return [ pinToSuperview(attribute: .left, spacing: insets.left),
                 pinToSuperview(attribute: .top, spacing: insets.top),
                 pinToSuperview(attribute: .right, spacing: -insets.right),
                 pinToSuperview(attribute: .bottom, spacing: -insets.bottom) ].flatMap { $0 }
    }
}

// MARK: - Roundable

protocol Roundable {
    func roundCorners(radius radiusOrNil: CGFloat?)
    func roundTopCorners(radius radiusOrNil: CGFloat?)
    func roundBottomCorners(radius radiusOrNil: CGFloat?)
}

extension UIView: Roundable {

    /// round all corners of view by radius
    /// default value adopt to rounding to make circle from square
    /// pass 0 to remove rounding

    func roundCorners(radius radiusOrNil: CGFloat? = nil) {

        let radius = radiusOrNil ?? 0.5 * min(bounds.width, bounds.height)
        layer.cornerRadius  = radius
        layer.masksToBounds = radius != 0
    }

    /// round only top-left & top-right corners

    func roundTopCorners(radius radiusOrNil: CGFloat? = nil) {
        let radius = radiusOrNil ?? 0.5 * min(bounds.width, bounds.height)
        layer.mask = mask(by: [.topLeft, .topRight], radius: radius)
        layer.masksToBounds = layer.mask != nil
    }

    /// round only bottom-left & bottom-right corners

    func roundBottomCorners(radius radiusOrNil: CGFloat? = nil) {
        let radius = radiusOrNil ?? 0.5 * min(bounds.width, bounds.height)
        layer.mask = mask(by: [.bottomLeft, .bottomRight], radius: radius)
        layer.masksToBounds = layer.mask != nil
    }

    fileprivate func mask(by roundingCorners: UIRectCorner, radius: CGFloat) -> CAShapeLayer? {
        guard radius != 0 else { return nil }

        let maskLayer  = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds,
                                      byRoundingCorners: roundingCorners,
                                      cornerRadii: CGSize(width: radius, height: radius)).cgPath

		maskLayer.fillColor       = UIColor.black.cgColor
		maskLayer.backgroundColor = UIColor.white.cgColor

        return maskLayer
    }
}

// MARK: - OnEventClosures

protocol OnEventClosures: class {
	var onWillAppear:    () -> Void { get set }
	var onDidAppear:     () -> Void { get set }
	var onWillDisappear: () -> Void { get set }
	var onDidDisappear:  () -> Void { get set }
	var onClose:         () -> Void { get set }
	var onDidLoad:       () -> Void { get set }
}

class DeclarativeViewController: UIViewController, OnEventClosures {
	
	// MARK: OnEventClosures
	
	var onWillAppear:    () -> Void = {}
	var onDidAppear:     () -> Void = {}
	var onWillDisappear: () -> Void = {}
	var onDidDisappear:  () -> Void = {}
	var onClose:         () -> Void = {}
	var onDidLoad:       () -> Void = {}
	
	// MARK: Overrides
	
	override func viewDidLoad()                       { super.viewDidLoad();               onDidLoad()       }
	override func viewWillAppear(_ animated: Bool)    { super.viewWillAppear(animated);    onWillAppear()    }
	override func viewDidAppear(_ animated: Bool)     { super.viewDidAppear(animated);     onDidAppear()     }
	override func viewWillDisappear(_ animated: Bool) { super.viewWillDisappear(animated); onWillDisappear() }
	override func viewDidDisappear(_ animated: Bool)  { super.viewDidDisappear(animated);  onDidDisappear()  }
}

// MARK: - Empty Header/Footer view

extension UIView {
	static var transparentView: UIView {
		let view = UIView(frame: CGRect.zero)
		view.backgroundColor = UIColor.clear
		return view
	}
}

extension UITextField {
    @discardableResult
    func onTextChanges(_ closure: @escaping (Notification) -> Void) -> Self {
        NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange,
                                               object: self,
                                               queue: .main,
                                               using: closure)
        return self
    }
}

extension CGRect {
    func expanded(by offset: CGFloat) -> CGRect {
        return CGRect(x: origin.x - offset,
                      y: origin.y - offset,
                      width: size.width + 2 * offset,
                      height: size.height + 2 * offset)
    }
}













