//
//  TemplatedFormatter.swift
//  Tools
//
//  Created by Oleg Ketrar on 04.07.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

/// format may contain
/// Z - any character;
/// 9 - any digit;
/// any other symbol in format will be recognized as constant
public struct TemplatedFormatter {
	private let source: String
	private var format: String = "*"

	// MARK: Init

	public init(_ str: String) {
		source = str
	}

	public func with(format: String) -> TemplatedFormatter {
		var copy = self
		copy.format = format
		return copy
	}

	private func isValidSeparator(_ str: String) -> Bool {
		return str != "9" && str != "Z"
	}

	// MARK: Formatting

	public func formatted(byReplacing string: String, in range: NSRange) -> String {

		// handle default format
		guard format != "*" else { return (source as NSString).replacingCharacters(in: range, with: string) }

		// handle deletion
		guard !string.isEmpty else {
			let newSource = (source as NSString).replacingCharacters(in: range, with: string)

			// append separator if next template character is separator
			let nextCharRange = NSRange(location: range.location + 1, length: -1)

			guard let separator = (format as NSString).safeSubstring(with: nextCharRange),
				isValidSeparator(separator) else { return newSource }

			return newSource.appending(separator)
		}

		// validate length
		guard (source as NSString).replacingCharacters(in: range, with: string).characters.count <= format.characters.count else {
			return source
		}

		// FIXME: enable pasting more that 1 character
		guard string.characters.count == 1 else { return source }

		let formatRange: NSRange = {
			guard range.length > 0 else { return NSRange(location: range.location, length: 1) }
			return range
		}()

		let isValid: Bool = {
			switch (format as NSString).substring(with: formatRange) {
			case "Z": return string.validate(regex: "[A-Za-z]{1}")
			case "9": return string.validate(regex: "[0-9]{1}")
			default:  return false
			}
		}()

		let newSource: String = {
			if isValid {
				return (source as NSString).replacingCharacters(in: range, with: string)
			} else {
				return source
			}
		}()

		// append separator if next template character is separator
		let nextCharRange = NSRange(location: range.location + 1, length: 1)

		guard let separator = (format as NSString).safeSubstring(with: nextCharRange),
			isValidSeparator(separator) else { return newSource }

		return newSource.appending(separator)
	}

	/*
	func constCharsRange(forLocation location: Int, ascending: Bool = true) -> NSRange? {
	guard location > 0,
	location < format.characters.count else { return nil }

	let lenght: Int = {
	var i: Int = 0

	func index(for index: Int) -> String.Index {
	return format.index(format.startIndex, offsetBy: index)
	}

	while isValidSeparator(String(format[index(for: location + i)]))
	&& (location + i) < format.characters.count {

	i = i + (ascending ? 1 : -1)
	}

	return i
	}()

	guard lenght != 0 else { return nil }
	return NSRange(location: location, length: lenght)
	}
	*/
}
