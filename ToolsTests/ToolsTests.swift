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
        Input(now: "12")
            .convert { $0 + "34" }
            .convert { Int($0) }
            .then {
                if case let .success(integer) = $0 {
                    XCTAssertEqual(integer, 1234)
                } else {
                    XCTFail()
                }
        }
    }

    func testConvertEachTask() {
        Input(now: ["1", "2", "3"])
            .map { $0 + "1" }
            .flatMap { Int($0) }
            .convert { (array: [Int]) -> Int in array.reduce(0, +) }
            .then { (sum: Int) in
                XCTAssertEqual(sum, 11 + 21 + 31)
        }
    }

    func testConvertFailableTask() {
        XCTAssertTrue(true)
    }

    func testConvertEachFailableTask() {
        XCTAssertTrue(true)
    }

    // MARK: - Chaining

    func testTaskChaining() {
        XCTAssertTrue(true)
    }

    func testFailableTaskChaining() {
        XCTAssertTrue(true)
    }

    // MARK: - Awaiting

    func testTaskAwaiting() {
        XCTAssertTrue(true)
    }

    // MAKR: - 

    func testOnSuccess() {
        XCTAssertTrue(true)
    }

    func testCatchingError() {
        XCTAssertTrue(true)
    }
}











