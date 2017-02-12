//
//  Permissions.swift
//  Tools
//
//  Created by Oleg Ketrar on 10.02.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

// MARK: - Permissions

public enum Permission: String {
	case camera         = "camera"
	case photo          = "photo"
	case location       = "location when in use"
	case notifications  = "notifications"
}

extension Permission: CustomDebugStringConvertible {
	public var debugDescription: String { return "permission denied \(rawValue)" }
}

extension Permission: CustomLocalizedStringConvertible {
	public var localizedDescription: String {
		switch self {
		case .camera:			return "PERMISSION_CAMERA_NEEDED".localized
		case .photo:			return "PERMISSION_PHOTO_NEEDED".localized
		case .location:			return "PERMISSION_LOCATION_NEEDED".localized
		case .notifications:	return "PERMISSION_NOTIFICATIONS_NEEDED".localized
		}
	}
}
