//
//  MailComposeViewController.swift
//  Tools
//
//  Created by Oleg Ketrar on 04.07.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import MessageUI

/// Convenience Block-based `MFMailComposeViewController`.
/// `delegate` property used by itself.
/// You should not change `delegate` after initialization with `convenience init(_ callback:)`.
/// But you still can use it as normal `MFMailComposeViewController` by creating with `designated` initializer.
public final class MailComposeViewController: MFMailComposeViewController, MFMailComposeViewControllerDelegate {
    private var callbackClosure: (MFMailComposeViewController, MFMailComposeResult, Error?) -> Void = { _, _, _ in }

    /// - parameter callback: will be called instead of `mailComposeController(_ controller: didFinishWith:)`.
    public convenience init(_ callback: @escaping (MFMailComposeViewController, MFMailComposeResult, Error?) -> Void) {
        self.init()

        callbackClosure     = callback
        mailComposeDelegate = self
    }

    // MARK: MFMailComposeViewControllerDelegate

    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        callbackClosure(controller, result, error)
    }
}
