//
//  AppErrorAlert.swift
//  Tools
//
//  Created by Oleg Ketrar on 2/10/17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

// MARK: Bridge to Alert sequence dispatching

extension AppError {
	var alert: Alert {
		
		/// non-printable errors produce empty alert
		guard isUserPrintable else { debugPrint(description); return Alert.empty }
		
		switch self {
		case .network:
			return Alert.alert(title: "ERROR_NETWORK_UNAVAILABLE".localized,
			                   message: "ERROR_NETWORK_UNAVAILABLE_MESSAGE".localized).dispatched(false)
			
		case .permissionDenied(let neededPermission):
			return Alert.permission(neededPermission).priority(.high)
			
		default:
			return Alert.alert(title: localizedDescription).dispatched(false)
		}
	}
	
	// MARK: Convenience alert dispatching
	
	/// present error alert now if can otherwise ignore
	/// if alert queue overflowed alert will never be shown
	func present(delay: TimeInterval = 0, onClose: @escaping () -> Void = {}) {
		alert.waitOnAppear(delay).onCompletion(onClose).present()
	}
	
	/// send error alert to alert queue
	/// alert will be shown guaranteed
	func enqueue(delay: TimeInterval = 0, onClose: @escaping () -> Void = {}) {
		alert.waitOnAppear(delay).onCompletion(onClose).enqueue()
	}
	
	func dispatch(delay: TimeInterval = 0, onClose: @escaping () -> Void = {}) {
		alert.waitOnAppear(delay).onCompletion(onClose).dispatch()
	}
}

private extension Alert {
	/// notify user that appropriate permission needed
	/// user can cancel it or navigate to app permission settings
	static func permission(_ permission: Permission) -> Alert {
		return Alert.dialog(title: "ALERT_NEEDED_PERMISSION_DENIED".localized,
		                    message: permission.localizedDescription,
		                    actionTitle: "ALERT_OPEN_SETTINGS_TITLE".localized,
		                    actionClosure: { _ = UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!) })
	}
}







