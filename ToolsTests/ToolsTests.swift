//
//  ToolsTests.swift
//  ToolsTests
//
//  Created by Oleg Ketrar on 2.10.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import XCTest
import Tools

class TaskTests: XCTestCase {

    // MARK: - Input, Task.convert, Task.then(closure:)

    func testInput() {
        Input(now: "My Name")
            .convert { $0 + " is Oleg" }
            .then { XCTAssertEqual("My Name is Oleg", $0) }
    }

    func testLazyInput() {
        class PersonMock {
            var isNameCreated: Bool = false
            var lazyName: String {
                isNameCreated = true
                return "Oleg"
            }
        }

        let person = PersonMock()
        let input  = Input(lazy: person.lazyName).convert { "name is \($0)" }

        // check lazy
        XCTAssertFalse(person.isNameCreated)

        input.then { _ in
            XCTAssertTrue(person.isNameCreated)
        }
    }

    // MARK: - Convert

    func testConvertTask() {
        XCTFail()
    }

    func testConvertEachTask() {
        XCTFail()
    }

    func testConvertFailableTask() {
        XCTFail()
    }

    func testConvertEachFailableTask() {
        XCTFail()
    }

    // MARK: - Chaining

    func testTaskChaining() {
        XCTFail()
    }

    func testFailableTaskChaining() {
        XCTFail()
    }

    // MARK: - Awaiting

    func testTaskAwaiting() {
        XCTFail()
    }

    // MAKR: - 

    func testOnSuccess() {
        XCTFail()
    }

    func testCatchingError() {
        XCTFail()
    }
}











