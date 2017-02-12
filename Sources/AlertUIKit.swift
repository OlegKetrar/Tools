//
//  AlertUIKit.swift
//  Tools
//
//  Created by Oleg Ketrar on 10.02.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import UIKit

// MARK: - Wrap UIAlertController into Alert

extension Alert {
	
	/// recursivelly find top UIViewController
	public static var topViewController: UIViewController {
		guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
			fatalError("UIApplication.keyWindow does not have rootViewController")
		}
		
		func presentedVC(to parent: UIViewController) -> UIViewController {
			if let modal = parent.presentedViewController {
				return presentedVC(to: modal)
			} else {
				return parent
			}
		}
		return presentedVC(to: rootVC)
		
	}
	
	/// simple alert with ok button
	public static func alert(title: String,
	                  message: String? = nil,
	                  cancelTitle: String = "Ok".localized(with: .UIKit),
	                  completion: @escaping () -> Void = {}) -> Alert {
		
		return Alert { (onFinish) in
			let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
			let cancel = UIAlertAction(title: cancelTitle, style: .default) { _ in delay { onFinish(); completion() }}
			alert.addAction(cancel)
			
			Alert.topViewController.present(alert, animated: true)
		}
	}
	
	/// dialog with action & cancel buttons (perform action with UI request)
	public static func dialog(title: String,
	                   message: String? = nil,
	                   cancelTitle: String = "Cancel".localized(with: .UIKit),
	                   actionTitle: String = "Ok".localized(with: .UIKit),
	                   isDestructive: Bool = false,
	                   actionClosure: @escaping () -> Void,
	                   completion: @escaping () -> Void = {}) -> Alert {
		
		return Alert { (onFinish) in
			let actionStyle = isDestructive ? UIAlertActionStyle.destructive : UIAlertActionStyle.default
			
			let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
			let cancel = UIAlertAction(title: cancelTitle, style: .cancel) { _ in delay { onFinish(); completion() }}
			let action = UIAlertAction(title: actionTitle, style: actionStyle) { _ in delay { onFinish(); actionClosure(); completion() }}
			
			alert.addAction(cancel)
			alert.addAction(action)
			
			Alert.topViewController.present(alert, animated: true)
		}
	}
}

// MARK: - Convenience closures

/// we need add delay to onFinish closure because
/// onFinish will be called before animation
/// (standart dismiss animation delay is 0.33 seconds = 330 milliseconds)

private func delayed(_ closure: @escaping () -> Void) -> () -> Void {
	return { DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(350)) { closure() } }
}

private func delay(_ closure: @escaping () -> Void) {
	delayed(closure)()
}

private extension Bundle {
    static var UIKit: Bundle? {
        return Bundle(identifier: "com.apple.UIKit")
    }
}
