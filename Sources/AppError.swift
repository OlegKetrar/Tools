//
//  Error.swift
//  Tools
//
//  Created by Oleg Ketrar on 10.02.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

public protocol CustomLocalizedStringConvertible {
	var localizedDescription: String { get }
}

public enum AppError: Swift.Error {
	case network
	case backend(statusCode: Int, reason: String)
	case authentication(reason: String)
	case parsing
	case logic(reason: String)
	case storage(reason: String)
	case localized(reason: String)
	case unexpected
	case unexpectedLocalized(reason: String)
	case permissionDenied(Permission)
	
	var isInternal: Bool {
		
		switch self {
		case .logic(_), .parsing(_): return true
		default: return false
		}
	}
}

extension AppError: CustomStringConvertible, Equatable {
	
	public var description: String {
		switch self {
		case .network:									return "network unavailable"
		case .backend(let statusCode, let reason):		return "backend(\(statusCode)) -> \(reason)"
		case .authentication(let reason):				return "authentication -> \(reason)"
		case .parsing:									return "parsing"
		case .logic(let reason):						return "logic -> \(reason)"
		case .storage(reason: let reason):				return "storage -> \(reason)"
		case .localized(reason: _):						return "localized -> \(self.localizedDescription)"
		case .unexpected:								return "unexpected error"
		case .unexpectedLocalized(reason: let reason):	return "unexpected -> \(reason)"
		case .permissionDenied(let p):					return "permission denied -> \(p.debugDescription)"
		}
	}
}

public func ==(lfs: AppError, rfs: AppError) -> Bool {
	return lfs.description == rfs.description
}

extension AppError {
	public init(unexpected: Error) {
		switch unexpected {
		// FIXME: permission error recognition
		case let nsError as NSError where nsError.domain == "AVFoundationErrorDomain":
			self = .permissionDenied(.camera)
			
		default:
			self = unexpected as? AppError ?? AppError.unexpected
		}
	}
}

// MARK: - Print to user

extension AppError: CustomLocalizedStringConvertible {
	public var isUserPrintable: Bool {
		switch self {
		case .network(reason: _),
		     .localized(reason: _),
		     .authentication(reason:_),
		     .permissionDenied(_),
		     .unexpectedLocalized(reason: _),
		     .backend(statusCode: _, reason: _): return true
			
		default: return false
		}
	}
	
	public var localizedDescription: String {
		switch self {
		case .network:								return ""
		case .authentication(reason: _):			return "ERROR_NOT_AUTHED".localized
		case .backend(statusCode: _, reason: _):	return "ERROR_SERVER_UNAVAILABLE".localized
		case .localized(reason: let reason):		return reason.localized
		case .unexpectedLocalized(reason: _):		return "SOMETHING_GO_WRONG".localized
		case .permissionDenied(let p):				return p.localizedDescription
		default: return ""
		}
	}
}
