//
//  Task.swift
//  Tools
//
//  Created by Oleg Ketrar on 03/07/17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

// TODO: extendable errors

enum TaskError: Error {
    case empty
}

// MARK: - Result

public enum Result<T> {
    case success(T)
    case failure(Error)
}

extension Result {
    public static var emptySuccess: Result<Void> {
        return Result<Void>.success(Void())
    }

    public var isSuccess: Bool {
        if case .success = self {
            return true
        } else {
            return false
        }
    }
}

// MARK: - Task

public protocol Task {
    associatedtype Input
    associatedtype Output

    typealias Completion = (Output) -> Void

    var completionClosure: Completion { get set }
    var execute: (Input) -> Void      { get }
}

public extension Task {
    @discardableResult
    public func onCompletion(_ closure: @escaping Completion) -> Self {
        var copy = self
        copy.completionClosure = closure
        return copy
    }
}

// MARK: - FailableTask

public protocol FailableTask: Task {
    typealias Output = Result<SuccessOutput>
    associatedtype SuccessOutput
}

// MARK: - ConditionalTask

public protocol ConditionalTask: FailableTask {
    typealias Condition  = () -> Bool
    typealias Handler    = (Input, @escaping (Result<SuccessOutput>) -> Void) -> Void

    var conditionClosure: Condition { get set }
    var workClosure: Handler        { get }
}

public extension ConditionalTask {
    var execute: (Input) -> Void {
        let copy = self
        return { (input) in
            if copy.conditionClosure() {
                copy.workClosure(input, copy.completionClosure)
            } else {
                copy.completionClosure(.failure(TaskError.empty))
            }
        }
    }

    @discardableResult
    public func withCondition(_ closure: @escaping Condition) -> Self {
        var copy = self
        copy.conditionClosure = closure
        return copy
    }
}

////

public struct SimpleTask<In, Out>: Task {
    public typealias Input  = In
    public typealias Output = Out

    private var workClosure: (In, @escaping (Out) -> Void) -> Void
    public var completionClosure: (Out) -> Void = { _ in }

    public var execute: (In) -> Void {
        return { self.workClosure($0, self.completionClosure) }
    }

    public init(_ closure: @escaping (In, @escaping (Out) -> Void) -> Void) {
        workClosure = closure
    }
}

public struct FailableSimpleTask<In, Out>: FailableTask {
    public typealias Input         = In
    public typealias SuccessOutput = Out

    private var workClosure: (In, @escaping (Result<Out>) -> Void) -> Void
    public var completionClosure: (Result<Out>) -> Void = { _ in }

    public var execute: (In) -> Void {
        return { self.workClosure($0, self.completionClosure) }
    }

    public init(_ closure: @escaping (In, @escaping (Result<Out>) -> Void) -> Void) {
        workClosure = closure
    }
}

/// TODO: Abstract Chaining

public struct Chain<In, Out>: Task {
    public typealias Input  = In
    public typealias Output = Out

    private var workClosure: (In, @escaping (Out) -> Void) -> Void
    public var completionClosure: (Out) -> Void = { _ in }

    public var execute: (In) -> Void {
        return { self.workClosure($0, self.completionClosure) }
    }

    /// Task -> Task
    fileprivate init<T: Task, V: Task>(firstTask: T, secondTask: V)
        where T.Input == In, T.Output == V.Input, V.Output == Out {

            workClosure = { (input, onCompletion) in
                firstTask.onCompletion { (firstOutput) in
                    secondTask.onCompletion { onCompletion($0) }.execute(firstOutput)
                }.execute(input)
            }
    }
}

public struct FailableChain<In, Out>: FailableTask {
    public typealias Input         = In
    public typealias SuccessOutput = Out

    private var workClosure: (In, @escaping (Result<Out>) -> Void) -> Void
    public var completionClosure: (Result<Out>) -> Void = { _ in }

    public var execute: (In) -> Void {
        return { self.workClosure($0, self.completionClosure) }
    }

    // MAKR: - Task Chaining

    /// Failable -> Failable
    fileprivate init<T: FailableTask, V: FailableTask>(firstTask: T, secondTask: V)
        where T.Input == In, T.SuccessOutput == V.Input, V.SuccessOutput == Out {

            workClosure = { (input, onCompletion) in
                firstTask.onCompletion { (result) in
                    switch result {
                    case .success(let output):
                        secondTask.onCompletion(onCompletion).execute(output)

                    case .failure:
                        onCompletion(.failure(TaskError.empty))
                    }
                }.execute(input)
            }
    }

    /// Task -> Failable
    fileprivate init<T: Task, V: FailableTask>(firstTask: T, secondTask: V)
        where T.Input == In, T.Output == V.Input, V.SuccessOutput == Out {

            workClosure = { (input, onCompletion) in
                firstTask.onCompletion { (firstOutput) in
                    secondTask.onCompletion { onCompletion($0) }.execute(firstOutput)
                }.execute(input)
            }
    }
}

public extension Task {
    public func then<T: Task>(_ nextTask: T) -> Chain<Input, T.Output> where T.Input == Output {
        return Chain(firstTask: self, secondTask: nextTask)
    }

    public func then<T: Task>(_ nextTask: () -> T) -> Chain<Input, T.Output> where T.Input == Output {
        return then(nextTask())
    }

    public func then<T: FailableTask>(_ nextTask: T) -> FailableChain<Input, T.SuccessOutput> where T.Input == Output {
        return FailableChain(firstTask: self, secondTask: nextTask)
    }

    public func then<T: FailableTask>(_ nextTask: () -> T) -> FailableChain<Input, T.SuccessOutput> where T.Input == Output {
        return then(nextTask())
    }
}

public extension FailableTask {
    public func then<T: FailableTask>(_ nextTask: T) -> FailableChain<Input, T.SuccessOutput> where T.Input == SuccessOutput {
        return FailableChain(firstTask: self, secondTask: nextTask)
    }

    public func then<T: FailableTask>(_ nextTask: () -> T) -> FailableChain<Input, T.SuccessOutput> where T.Input == SuccessOutput {
        return then(nextTask())
    }
}

// MARK: - Convertion

public extension Task {
    public func convert<T>(_ closure: @escaping (Output) -> T) -> Chain<Input, T> {
        return then( SimpleTask { $1( closure($0) ) })
    }

    public func convert<T>(_ closure: @escaping (Output) -> Optional<T>) -> FailableChain<Input, T> {
        return then( FailableSimpleTask { (input, onCompletion) in
            if let converted = closure(input) {
                onCompletion(.success(converted))
            } else {
                onCompletion(.failure(TaskError.empty))
            }
        })
    }
}

public extension Task where Output: Sequence {
    public func convertEach<T>(_ closure: @escaping (Output.Iterator.Element) -> T) -> Chain<Input, Array<T>> {
        return then ( SimpleTask { $1( $0.map { closure($0) }) })
    }

    public func convertEach<T>(_ closure: @escaping (Output.Iterator.Element) -> Optional<T>) -> Chain<Input, Array<T>> {
        return then( SimpleTask { $1( $0.flatMap { closure($0) }) })
    }
}

public extension FailableTask {
    public func convert<T>(_ closure: @escaping (SuccessOutput) -> T) -> FailableChain<Input, T> {
        return then( FailableSimpleTask { $1(.success(closure($0))) })
    }
}

public extension FailableTask where SuccessOutput: Sequence {
    public func convertEach<T>(_ closure: @escaping (SuccessOutput.Iterator.Element) -> Optional<T>) -> FailableChain<Input, Array<T>> {
        return then( FailableSimpleTask { $1(.success( $0.flatMap { closure($0) })) })
    }
}

// MARK: - Provide data

public struct Input<Data>: Task {
    public typealias Input  = Void
    public typealias Output = Data

    private var workClosure: (Void, @escaping (Data) -> Void) -> Void
    public var completionClosure: (Data) -> Void = { _ in }

    public var execute: () -> Void {
        return { self.workClosure($0, self.completionClosure) }
    }

    public init(now data: Data) {
        workClosure = { $1(data) }
    }

    public init(lazy dataClosure: @autoclosure @escaping () -> Data) {
        workClosure = { $1(dataClosure()) }
    }
}

// MAKR: - Awaiting

public extension Task where Input == Void {
    public func awaitForResult<T: Task>(from task: T) -> SimpleTask<Void, (Output, T.Output)> where T.Input == Void {
        return SimpleTask { (input, onCompletion) in
            let group = DispatchGroup()

            var firstResult: Optional<Output>    = .none
            var secondResult: Optional<T.Output> = .none

            group.enter()
            group.enter()

            group.notify(queue: .main) {
                guard case let .some(first) = firstResult,
                    case let .some(second) = secondResult else { fatalError("awaitingError") }

                onCompletion((first, second))
            }

            self.onCompletion { firstResult = .some($0); group.leave() }.execute(input)
            task.onCompletion { secondResult = .some($0); group.leave() }.execute(input)
        }
    }
}

// MAKR: - Execution

public extension Task where Input == Void {

    /// execute with completion
    public func then(_ closure: @escaping (Output) -> Void) {
        onCompletion(closure).execute()
    }
}

public extension FailableTask where Input == Void {

    /// execute with completion only on success
    public func onSuccess(_ closure: @escaping (SuccessOutput) -> Void) {
        onCompletion { (result) in
            guard case .success(let output) = result else { return }
            closure(output)
        }.execute()
    }
}

public extension FailableTask {

    /// handle error with specified closure
    public func `catch`(_ closure: @escaping (Error) -> Void) -> SimpleTask<Input, SuccessOutput> {
        return SimpleTask { (input, onCompletion) in
            self.onCompletion { (result) in
                switch result {
                case let .success(data):  onCompletion(data)
                case let .failure(error): closure(error)
                }
            }.execute(input)
        }
    }
}
