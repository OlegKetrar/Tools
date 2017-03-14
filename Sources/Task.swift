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

enum Result<T> {
    case success(T)
    case failure(Error)
}

extension Result {
    static var emptySuccess: Result<Void> {
        return Result<Void>.success(Void())
    }

    var isSuccess: Bool {
        if case .success = self {
            return true
        } else {
            return false
        }
    }
}

// MARK: - Task

protocol Task {
    associatedtype Input
    associatedtype Output

    typealias Completion = (Output) -> Void

    var completionClosure: Completion { get set }
    var execute: (Input) -> Void      { get }
}

extension Task {
    @discardableResult
    func onCompletion(_ closure: @escaping Completion) -> Self {
        var copy = self
        copy.completionClosure = closure
        return copy
    }
}

// MARK: - FailableTask

protocol FailableTask: Task {
    typealias Output = Result<SuccessOutput>
    associatedtype SuccessOutput
}

// MARK: - ConditionalTask

protocol ConditionalTask: FailableTask {
    typealias Condition  = () -> Bool
    typealias Handler    = (Input, @escaping Completion) -> Void

    var conditionClosure: Condition { get set }
    var workClosure: Handler        { get }
}

extension ConditionalTask {
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
    func withCondition(_ closure: @escaping Condition) -> Self {
        var copy = self
        copy.conditionClosure = closure
        return copy
    }
}

// MARK: SimpleTask

struct SimpleTask<In, Out>: Task {
    typealias Input         = In
    typealias Output = Out

    var workClosure: (In, @escaping (Out) -> Void) -> Void
    var completionClosure: (Out) -> Void = { _ in }

    var execute: (In) -> Void {
        return { self.workClosure($0, self.completionClosure) }
    }

    init(_ closure: @escaping (In, @escaping (Out) -> Void) -> Void) {
        workClosure = closure
    }
}

struct FailableSimpleTask<In, Out>: FailableTask {
    typealias Input         = In
    typealias SuccessOutput = Out

    var workClosure: (In, @escaping (Result<Out>) -> Void) -> Void
    var completionClosure: (Result<Out>) -> Void = { _ in }

    var execute: (In) -> Void {
        return { self.workClosure($0, self.completionClosure) }
    }

    init(_ closure: @escaping (In, @escaping (Result<Out>) -> Void) -> Void) {
        workClosure = closure
    }
}

/// TODO: Abstract Chaining

struct Chain<In, Out>: Task {
    typealias Input  = In
    typealias Output = Out

    var workClosure: (In, @escaping (Out) -> Void) -> Void
    var completionClosure: (Out) -> Void = { _ in }

    var execute: (In) -> Void {
        return { self.workClosure($0, self.completionClosure) }
    }

    /// failableChain from non failable tasks
    fileprivate init<T: Task, V: Task>(firstTask: T, secondTask: V)
        where T.Input == In, T.Output == V.Input, V.Output == Out {

            workClosure = { (input, onCompletion) in
                firstTask.onCompletion { (firstOutput) in
                    secondTask.onCompletion { onCompletion($0) }.execute(firstOutput)
                }.execute(input)
            }
    }
}

struct FailableChain<In, Out>: FailableTask {
    typealias Input         = In
    typealias SuccessOutput = Out

    var workClosure: (In, @escaping (Result<Out>) -> Void) -> Void
    var completionClosure: (Result<Out>) -> Void = { _ in }

    var execute: (In) -> Void {
        return { self.workClosure($0, self.completionClosure) }
    }

    // MAKR: - Task Chaining

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
}

extension Task {
    func then<T: Task>(_ nextTask: T) -> Chain<Input, T.Output> where T.Input == Output {
        return Chain(firstTask: self, secondTask: nextTask)
    }

    func then<T: Task>(_ nextTask: () -> T) -> Chain<Input, T.Output> where T.Input == Output {
        return then(nextTask())
    }
}

extension FailableTask {
    func then<T: FailableTask>(_ nextTask: T) -> FailableChain<Input, T.SuccessOutput> where T.Input == SuccessOutput {
        return FailableChain(firstTask: self, secondTask: nextTask)
    }

    func then<T: FailableTask>(_ nextTask: () -> T) -> FailableChain<Input, T.SuccessOutput> where T.Input == SuccessOutput {
        return then(nextTask())
    }
}

// MARK: - Convertion

extension Task {
    func convert<T>(_ closure: @escaping (Output) -> T) -> Chain<Input, T> {
        return then( SimpleTask { $1( closure($0) ) })
    }
}

extension Task where Output: Sequence {
    func convertEach<T>(_ closure: @escaping (Output.Iterator.Element) -> T) -> Chain<Input, Array<T>> {
        return then ( SimpleTask { $1( $0.flatMap { closure($0) }) })
    }
}

extension FailableTask {
    func convert<T>(_ closure: @escaping (SuccessOutput) -> Optional<T>) -> FailableChain<Input, T> {
        return then( FailableSimpleTask { (input, onCompletion) in
            if let converted = closure(input) {
                onCompletion(.success(converted))
            } else {
                onCompletion(.failure(TaskError.empty))
            }
        })
    }
}

extension FailableTask where SuccessOutput: Sequence {
    func convertEach<T>(_ closure: @escaping (SuccessOutput.Iterator.Element) -> Optional<T>) -> FailableChain<Input, Array<T>> {
        return then( FailableSimpleTask { $1(.success( $0.flatMap { closure($0) })) })
    }
}

// MARK: - Provide data

struct Input<Data>: Task {
    typealias Input  = Void
    typealias Output = Data

    var workClosure: (Void, @escaping (Data) -> Void) -> Void
    var completionClosure: (Data) -> Void = { _ in }

    var execute: () -> Void {
        return { self.workClosure($0, self.completionClosure) }
    }

    init(now data: Data) {
        workClosure = { $1(data) }
    }

    init(lazy dataClosure: @autoclosure @escaping () -> Data) {
        workClosure = { $1(dataClosure()) }
    }
}

// MAKR: - Parallel Execution

extension Task where Input == Void {
    func awaitForResult<T: Task>(from task: T) -> SimpleTask<Void, (Output, T.Output)> where T.Input == Void {
        return SimpleTask { (input, onCompletion) in
            let group = DispatchGroup()

            var firstResult: Optional<Output>    = .none
            var secondResult: Optional<T.Output> = .none

            group.enter()
            group.enter()

            group.notify(queue: .main) {
                guard case let .some(first) = firstResult,
                    case let .some(second) = secondResult else { fatalError("") }

                onCompletion((first, second))
            }

            self.onCompletion { firstResult = .some($0); group.leave() }.execute(input)
            task.onCompletion { secondResult = .some($0); group.leave() }.execute(input)
        }
    }
}

// MAKR: - Execution

extension Task where Input == Void {

    /// execute with completion
    func then(_ closure: @escaping (Output) -> Void) {
        onCompletion(closure).execute()
    }
}

extension FailableTask where Input == Void {

    /// execute with completion only on success
    func onSuccess(_ closure: @escaping (SuccessOutput) -> Void) {
        onCompletion { (result) in
            guard case .success(let output) = result else { return }
            closure(output)
        }.execute()
    }
}

extension FailableTask {

    /// handle error with specified closure
    func `catch`(_ closure: @escaping (Error) -> Void) -> SimpleTask<Input, SuccessOutput> {
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
