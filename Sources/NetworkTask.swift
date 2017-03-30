//
//  NetworkTask.swift
//  Tools
//
//  Created by Oleg Ketrar on 03/07/17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation


// MARK: - Provide Data

public struct Input<Data>: Task {
    public typealias Input  = Void
    public typealias Output = Data

    public var execute: ((), @escaping (Data) -> Void) -> Void

    public init(now data: Data) {
        execute = { $1(data) }
    }

    public init(lazy dataClosure: @autoclosure @escaping () -> Data) {
        execute = { $1(dataClosure()) }
    }
}

/// MARK: - Send

struct JSON {
    var value: String = ""
}

/// T -> Result(JSON)
struct Send<T>: Task {
    typealias Input  = T
    typealias Output = Result<JSON>
    var execute: (T, @escaping (Result<JSON>) -> Void) -> Void

    init() {
        execute = { $1(.success(JSON(value: "a"))) }
    }
}

/// JSON -> Int
struct Parse: Task {
    typealias Input  = JSON
    typealias Output = Int
    var execute: (JSON, @escaping (Int) -> Void) -> Void

    init() {
        execute = { $1(10) }
    }
}

struct OptinalParse: Task {
    typealias Input  = JSON
    typealias Output = Result<Int>
    var execute: (JSON, @escaping (Result<Int>) -> Void) -> Void

    init() {
        execute = { $1(.success(10)) }
    }
}

/*
import Foundation
import Alamofire
import SwiftyJSON

protocol ApiConfig {
    var basepoint: String { get }
}

// MARK: - Request

struct Request {

    struct EmptyConfig: ApiConfig {
        var basepoint: String = ""
    }

    static var config: ApiConfig = EmptyConfig()

    var url: String
    var method: HTTPMethod
    var params: [String : Any]

    init(url: String, method: HTTPMethod = .get, parameters: [String : Any] = [:]) {
        self.url    = Request.config.basepoint + url
        self.method = method
        self.params = parameters
    }
}

// MARK: - NetworkTask

struct Send: ConditionalTask {
    typealias Input         = Void
    typealias SuccessOutput = JSON

    var workClosure: (Void, @escaping (Result<JSON>) -> Void) -> Void
    var conditionClosure: ConditionalTask.Condition          = { true }
    var completionClosure: (Result<JSON>) -> Void = { _ in }

    init(request: Request) {
        workClosure = { (_, onCompletion) in

            // TODO: set appropriate headers

            SessionManager.default
                .request(request.url, method: request.method, parameters: request.params)
                .validate(statusCode: 200..<205)
                .responseJSON { onCompletion(.json($0)) }
        }
    }
}

private extension Result {

    static func json(_ response: DataResponse<Any>) -> Result<JSON> {
        switch response.result {
        case .success(let encodedData):

            // FIXME: get value from response json
            return .success(JSON(encodedData))

        case .failure(_):

            // TODO: convert error to AppError
            return .failure(TaskError.empty)
        }
    }
}

// MARK: - ParsingTask

protocol JsonInitable {
    init?(_ json: JSON)
}

// TODO: parse to Task

extension FailableTask where SuccessOutput == JSON {
    func parse<T>(_ type: T.Type) -> FailableChain<Input, T> where T: JsonInitable {
        return convert { type.init($0) }
    }
}

extension FailableTask where SuccessOutput == Array<JSON> {
    func parseEach<T>(_ type: T.Type) -> FailableChain<Input, Array<T>> where T: JsonInitable {
        return convert { $0.flatMap { T($0) } }
    }
}
*/
