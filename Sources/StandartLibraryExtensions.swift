//
//  StandartLibraryExtensions.swift
//  Tools
//
//  Created by Oleg Ketrar on 10.02.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

extension Bool {
    public mutating func toggleValue() { self = !self }
    public func toggledValue() -> Bool { return !self }
}

// MARK: String + Base64 encoding/decoding

extension String {
    
    public var encodeBase64: String {
        return self.data(using: String.Encoding.utf8)?.base64EncodedString(options: []) ?? ""
    }
    
    public var decodeBase64: String {
        
        guard let strData = Data(base64Encoded: self, options: []) else { return "" }
        return (NSString(data: strData, encoding: String.Encoding.utf8.rawValue) ?? "") as String
    }
}

extension Data {
    
    public init?(urlSafeBase64String: String) {
        
        let rem = urlSafeBase64String.characters.count % 4
        
        var ending = ""
        if rem > 0 {
            let amount = 4 - rem
            ending = String(repeating: "=", count: amount)
        }
        
        let base64String = urlSafeBase64String.replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/") + ending
		
		self.init(base64Encoded: base64String)
	}
    
    public func urlSafeBase64String() -> String? {
        
        let data = self.base64EncodedData(options: [])
        guard let string = String(data: data, encoding: String.Encoding.utf8) else { return nil }
        
        return string.replacingOccurrences(of: "+", with: "-", options: [], range: nil)
            .replacingOccurrences(of: "/", with: "_", options: [], range: nil)
            .replacingOccurrences(of: "=", with: "", options: [], range: nil)
    }
}

// MARK: - Regex + String

extension String {
    public func validate(regex regStr: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regStr).evaluate(with: self)
    }
}

// MARK: - NSLocalizedString + String

extension String {
	public var localized: String {
		return NSLocalizedString(self, comment: "")
	}

	public func localized(with bundle: Bundle?) -> String {
		guard let bundle = bundle else { return localized }
		return bundle.localizedString(forKey: self, value: "", table: nil)
	}
}

// MARK: - Bound

extension Strideable {

	/// bound value between [min; max]
	public func bounded(min: Self, max: Self) -> Self {
		if self > max {
			return max
		} else if self < min {
			return min
		} else {
			return self
		}
	}
}

extension Strideable where Self: SignedNumber {

	/// bound between [-abs; abs]
	public func bounded(abs value: Self) -> Self {
		return bounded(min: -abs(value), max: abs(value))
	}
}
