//
//  Localization.swift
//  ToolsFoundation
//
//  Created by Oleg Ketrar on 26/03/2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation

public extension String {

    var encodeBase64: String {
        return self.data(using: .utf8)?.base64EncodedString(options: []) ?? ""
    }

    var decodeBase64: String {
        return Data(base64Encoded: self, options: [])
            .flatMap { NSString(data: $0, encoding: String.Encoding.utf8.rawValue) }
            .map { $0 as String } ?? ""
    }
}

public extension Data {

    init?(urlSafeBase64String: String) {
        let rem = urlSafeBase64String.utf8.count % 4

        var ending = ""
        if rem > 0 {
            let amount = 4 - rem
            ending = String(repeating: "=", count: amount)
        }

        let base64String = urlSafeBase64String
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/") + ending

        self.init(base64Encoded: base64String)
    }

    func urlSafeBase64String() -> String? {
        let data = self.base64EncodedData(options: [])
        guard let string = String(data: data, encoding: .utf8) else { return nil }

        return string
            .replacingOccurrences(of: "+", with: "-", options: [], range: nil)
            .replacingOccurrences(of: "/", with: "_", options: [], range: nil)
            .replacingOccurrences(of: "=", with: "", options: [], range: nil)
    }
}
