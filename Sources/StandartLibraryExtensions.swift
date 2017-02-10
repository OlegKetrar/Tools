//
//  StandartLibraryExtensions.swift
//  Tools
//
//  Created by Oleg Ketrar on 2/10/17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

extension Bool {
    mutating func toggleValue() { self = !self }
    func toggledValue() -> Bool { return !self }
}

// MARK: String + Base64 encoding/decoding

extension String {
    
    var encodeBase64: String {
        return self.data(using: String.Encoding.utf8)?.base64EncodedString(options: []) ?? ""
    }
    
    var decodeBase64: String {
        
        guard let strData = Data(base64Encoded: self, options: []) else { return "" }
        return (NSString(data: strData, encoding: String.Encoding.utf8.rawValue) ?? "") as String
    }
}

extension Data {
    
    init?(urlSafeBase64String: String) {
        
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
    
    func urlSafeBase64String() -> String? {
        
        let data = self.base64EncodedData(options: [])
        guard let string = String(data: data, encoding: String.Encoding.utf8) else { return nil }
        
        return string.replacingOccurrences(of: "+", with: "-", options: [], range: nil)
            .replacingOccurrences(of: "/", with: "_", options: [], range: nil)
            .replacingOccurrences(of: "=", with: "", options: [], range: nil)
    }
}

// MARK: - Regex + String

extension String {
    func validate(regex regStr: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regStr).evaluate(with: self)
    }
}

// MARK: - NSLocalizedString + String

extension String {
	var localized: String {
		return NSLocalizedString(self, comment: "")
	}

	func localized(with bundle: Bundle?) -> String {
		guard let bundle = bundle else { return localized }
		return bundle.localizedString(forKey: self, value: "", table: nil)
	}
}

// MARK: - Bound

extension Strideable {

	/// bound value between [min; max]
	func bounded(min: Self, max: Self) -> Self {
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
	func bounded(abs value: Self) -> Self {
		return bounded(min: -abs(value), max: abs(value))
	}
}








