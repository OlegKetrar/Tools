//
//  Localization.swift
//  Tools
//
//  Created by Oleg Ketrar on 26/03/2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation

public extension Bundle {
    static var UIKit: Bundle? {
        return Bundle(identifier: "com.apple.UIKit")
    }
}

public extension String {

    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func localized(with bundle: Bundle?) -> String {
        guard let bundle = bundle else { return localized }
        return bundle.localizedString(forKey: self, value: "", table: nil)
    }
}
