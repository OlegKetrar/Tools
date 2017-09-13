//
//  RoutingController.swift
//  Tools
//
//  Created by Oleg Ketrar on 04.07.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

/// Routing convenience.
/// Register app routes and handles it with `open(url:)` method.
public final class RoutingController {
    public typealias RouteHandler = ([String : Any]) -> Bool

    private let scheme: String
    private(set) fileprivate var registeredRoutes: [String : RouteHandler] = [:]

    /// - parameter scheme: usually app name.
    public init(scheme: String) {
        self.scheme = scheme
    }

    /// Register specified `route` for `handler`. Handler will be called if
    /// - parameter route: route path which will be handled by closure.
    /// - parameter handler: will handle specified route.
    public func register(route: String, for handler: @escaping RouteHandler) {
        registeredRoutes[route] = handler
    }

    /// Check if `url` scheme is a registered scheme.
    /// - parameter scheme: `URL` with cheked scheme.
    public func isValidScheme(url: URL) -> Bool {
        return url.scheme == scheme
    }

    /// Check if route in `url` already registered.
    /// - parameter url: url.
    public func isRegistered(url: URL) -> Bool {
        guard let route = route(from: url) else { return false }
        return registeredRoutes[route] != nil
    }

    /// Handles `url`.
    /// - parameter url: `URL` containing route with parameters.
    /// Used with `UIApplication.shared.open(url:)` method.
    @discardableResult
    public func open(url: URL) -> Bool {
        guard isRegistered(url: url),
            let route = route(from: url),
            let handler = registeredRoutes[route] else { return false }

        return handler(url.queryParams)
    }

    private func route(from url: URL) -> String? {
        guard let urlScheme = url.scheme,
            urlScheme == scheme else { return nil }

        return (url.host ?? "") + url.path
    }
}

private extension URL {

    /// Map query params and values to Disctionary.
    var queryParams: [String : Any] {
        guard let queryString = query else { return [:] }
        var params = Dictionary<String, Any>()

        queryString.components(separatedBy: "&").forEach { (pairStr) in
            let keyValuePair = pairStr.components(separatedBy: "=")
            guard keyValuePair.count == 2 else { return }
            params.updateValue(keyValuePair[1], forKey: keyValuePair[0])
        }

        return params
    }
}
