//
//  Router.swift
//  Tools
//
//  Created by Oleg Ketrar on 04.07.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

/*
public final class Router {
	fileprivate var routes = [String : (JSON) -> Bool]()

	/// register handler for route
	public func register(route: AppRoute, presentation: Bool = false, handler: @escaping (JSON) -> Bool) {
		routes[route.path] = handler
	}

	///
	public func route(_ route: AppRoute) -> Bool {
		guard let handler = routes[route.path] else { return false }
		return handler(route.params)
	}
}

public struct AppRoute {
	public let path: String
	public let params: JSON

	public init(path: String, params: JSON = .null) {
		self.path   = path
		self.params = params
	}

	public init(_ url: URL) {
		self.path = ""
		self.params = {
			guard let queryStr = url.query else { return .null }

			let array: [(String, Any)] = queryStr.components(separatedBy: "&").flatMap {
				let keyValuePair = $0.components(separatedBy: "=")
				guard keyValuePair.count == 2 else { return nil }
				return (keyValuePair[0], keyValuePair[1])
			}

			return JSON(dictionaryLiteral: array)
		}()
	}
}
*/
