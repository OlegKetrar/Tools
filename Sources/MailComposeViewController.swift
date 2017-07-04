//
//  MailComposeViewController.swift
//  Tools
//
//  Created by Oleg Ketrar on 04.07.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import MessageUI

public final class MailComposeViewController: MFMailComposeViewController, MFMailComposeViewControllerDelegate {
	private var callbackClosure: (MFMailComposeViewController, MFMailComposeResult, Error?) -> Void = { _ in }

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
