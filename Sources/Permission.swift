//
//  Permissions.swift
//  Tools
//
//  Created by Oleg Ketrar on 2/10/17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

// MARK: - Permissions

enum Permission: String {
	case camera         = "camera"
	case photo          = "photo"
	case location       = "location when in use"
	case notifications  = "notifications"
}

extension Permission: CustomDebugStringConvertible {
	var debugDescription: String { return "permission denied \(rawValue)" }
}

extension Permission: CustomLocalizedStringConvertible {
	var localizedDescription: String {
		switch self {
		case .camera:			return "PERMISSION_CAMERA_NEEDED".localized
		case .photo:			return "PERMISSION_PHOTO_NEEDED".localized
		case .location:			return "PERMISSION_LOCATION_NEEDED".localized
		case .notifications:	return "PERMISSION_NOTIFICATIONS_NEEDED".localized
		}
	}
}
