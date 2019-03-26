//
//  MailComposeViewController.swift
//  Tools
//
//  Created by Oleg Ketrar on 04.07.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

// TODO: fix lines

public struct MailSender {
    private let recipients: [String]

    public init(to recipient: String...) {
        self.recipients = recipient
    }

    public func send(
        on vc: UIViewController?,
        configure: (MailComposeViewController) -> Void) {

        guard MailComposeViewController.canSendMail() else {
            let mailUri = "mailto:\(recipients.joined(separator: ","))"
            URL(string: mailUri).map { _ = UIApplication.shared.openURL($0) }

            return
        }

        let mailVC = MailComposeViewController { controller, _, _ in
            controller.dismiss(animated: true, completion: nil)
        }

        mailVC.setToRecipients(recipients)
        configure(mailVC)

        vc?.present(mailVC, animated: true, completion: nil)
    }
}

/// Convenience Block-based `MFMailComposeViewController`.
/// `delegate` property used by itself.
/// You should not change `delegate` after initialization with `convenience init(_ callback:)`.
/// But you still can use it as normal `MFMailComposeViewController` by creating with `designated` initializer.
public final class MailComposeViewController: MFMailComposeViewController {
    private var callbackClosure: (MFMailComposeViewController, MFMailComposeResult, Error?) -> Void = { _, _, _ in }

    /// - parameter callback: will be called instead of `mailComposeController(_ controller: didFinishWith:)`.
    public convenience init(
        _ callback: @escaping (MFMailComposeViewController, MFMailComposeResult, Error?) -> Void) {

        self.init()
        callbackClosure = callback
        mailComposeDelegate = self
    }
}

// MARK: MFMailComposeViewControllerDelegate

extension MailComposeViewController: MFMailComposeViewControllerDelegate {

    public func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?) {

        callbackClosure(controller, result, error)
    }
}
