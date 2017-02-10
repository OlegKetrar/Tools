//
//  AlertDispatcher.swift
//  Tools
//
//  Created by Oleg Ketrar on 2/10/17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

// MARK: - Alert

struct Alert {
	typealias Handler = (@escaping () -> Void) -> Void
	
	var beforeDelay: TimeInterval = 0
	var afterDelay:  TimeInterval = 0
	var priority:    Operation.QueuePriority = .normal
	
	var isDispatchable: Bool = true
	var isIgnorable:    Bool = false
	
	private var presentationClosure: Alert.Handler
	private var conditionClosure:    () -> Bool = { return true }
	private(set) fileprivate var completionClosure: () -> Void = {}
	
	fileprivate var handlerClosure: Alert.Handler {
		return { (onFinish) in
			if self.conditionClosure() {
				self.presentationClosure(onFinish)
			} else {
				onFinish()
			}
		}
	}
	
	// MARK: Init
	
	init(_ closure: @escaping Alert.Handler) {
		self.presentationClosure = closure
	}
	
	init(presentNow closure: @escaping Alert.Handler) {
		self.isDispatchable      = false
		self.presentationClosure = closure
	}
	
	// MARK: Configuring
	
	@discardableResult
	func waitOnAppear(_ delay: TimeInterval) -> Alert {
		var copy = self
		copy.beforeDelay = delay
		return copy
	}
	
	@discardableResult
	func waitOnDisappear(_ delay: TimeInterval) -> Alert {
		var copy = self
		copy.afterDelay = delay
		return copy
	}
	
	@discardableResult
	func onCompletion(_ closure: @escaping () -> Void) -> Alert {
		var copy = self
		copy.completionClosure = closure
		return copy
	}
	
	@discardableResult
	func priority(_ newPriority: Operation.QueuePriority) -> Alert {
		var copy = self
		copy.priority = newPriority
		return copy
	}
	
	@discardableResult
	func dispatched(_ dispatch: Bool = true) -> Alert {
		var copy = self
		copy.isDispatchable = dispatch
		return copy
	}
	
	@discardableResult
	func ignored() -> Alert {
		var copy = self
		copy.isIgnorable = true
		return copy
	}
	
	@discardableResult
	func addCondition(_ closure: @escaping () -> Bool) -> Alert {
		var copy = self
		copy.conditionClosure = closure
		return copy
	}
	
	/// append completion closure to existing completion
	@discardableResult
	func addCompletion(_ closure: @escaping () -> Void) -> Alert {
		var copy = self
		let oldClosure = self.completionClosure
		copy.completionClosure = { oldClosure(); closure() }
		return copy
	}
}

extension Alert {
	static var empty: Alert { return Alert { $0() }.ignored() }
}

// MARK: - Dispatcher

private struct AlertDispatcher {
	private static let underlyingQueue: OperationQueue = {
		let queue = OperationQueue()
		queue.maxConcurrentOperationCount = 1
		queue.qualityOfService            = .background
		return queue
	}()
	
	// MARK: 
	
	static var isSuspended: Bool {
		get { return underlyingQueue.isSuspended }
		set { underlyingQueue.isSuspended = newValue }
	}
	
	// MARK: Dispatch
	
	fileprivate static func dispatch(alert: Alert) {
		
		// ignore ignorable alerts)
		guard !alert.isIgnorable else { return }
		
		// form operation with completion
		let alertOperation = AsyncBlockOperation(alert)
		alertOperation.addCompletionBlock {
			DispatchQueue.main.async { alert.completionClosure() }
		}
		
		/// dispatch if dispatchable
		/// or attempt to present now if queue is empty
		if alert.isDispatchable {
			underlyingQueue.addOperation(alertOperation)
		} else if underlyingQueue.operationCount == 0 {
			underlyingQueue.addOperation(alertOperation)
		}
	}
}

// MARK: - Wrap Alert into Operation subclass

private final class AsyncBlockOperation: Operation {
	
	private struct Const {
		static let stateKeyPath: String = "state"
	}
	
	// MARK:
	
	class func keyPathsForValuesAffectingIsReady()     -> Set<NSObject> { return [Const.stateKeyPath as NSObject] }
	class func keyPathsForValuesAffectingIsExecuting() -> Set<NSObject> { return [Const.stateKeyPath as NSObject] }
	class func keyPathsForValuesAffectingIsFinished()  -> Set<NSObject> { return [Const.stateKeyPath as NSObject] }
	
	// MARK: State machine
	
	private enum State {
		case initialized
		case executing
		case finished
		
		func canTransition(to newState: State) -> Bool {
			switch (self, newState) {
			case (.executing, .finished),
			     (.initialized, .executing):
				return true
				
			default:
				return false
			}
		}
	}
	
	private var _state = State.initialized
	private let stateLock = NSLock()
	
	private var state: State {
		get { return stateLock.withCriticalScope { _state } }
		set(newState) {
			/*
			It's important to note that the KVO notifications are NOT called from inside
			the lock. If they were, the app would deadlock, because in the middle of
			calling the `didChangeValueForKey()` method, the observers try to access
			properties like "isReady" or "isFinished". Since those methods also
			acquire the lock, then we'd be stuck waiting on our own lock. It's the
			classic definition of deadlock.
			*/
			willChangeValue(forKey: Const.stateKeyPath)
			stateLock.withCriticalScope {
				guard _state != .finished else { return }
				guard _state.canTransition(to: newState) else { fatalError("invalid state transition from \(_state) to \(newState)") }
				_state = newState
			}
			didChangeValue(forKey: Const.stateKeyPath)
		}
	}
	
	// MARK:
	
	fileprivate var delayAfter: TimeInterval  = 0
	fileprivate var delayBefore: TimeInterval = 0
	
	private let executionClosure: Alert.Handler
	
	init(_ closure: @escaping Alert.Handler) {
		self.executionClosure = closure
		super.init()
	}
	
	// MARK: Overrides
	
	override func main() {
		guard state == .initialized else { return }
		state = .executing
		
		DispatchQueue.main.asyncAfter(deadline: .now() + delayBefore + .nanoseconds(1)) { [weak self] in
			self?.executionClosure {
				guard let time = self?.delayAfter else { return }
				DispatchQueue.main.asyncAfter(deadline: .now() + time + .nanoseconds(1)) { self?.state = .finished }
			}
		}
	}
	
	override var isReady: Bool     { return state == .initialized && super.isReady }
	override var isExecuting: Bool { return state == .executing }
	override var isFinished: Bool  { return state == .finished }
	
	// MARK: Unsupported
	
	override func cancel() {}
	override func waitUntilFinished() {}
}

// MARK: - Convenience Operation

private extension Operation {
	/**
	Add a completion block to be executed after the `NSOperation` enters the
	"finished" state.
	*/
	func addCompletionBlock(_ block: @escaping (Void) -> Void) {
		if let existing = completionBlock {
			/*
			If we already have a completion block, we construct a new one by
			chaining them together.
			*/
			completionBlock = {
				existing()
				block()
			}
		}
		else {
			completionBlock = block
		}
	}
	
	/// Add multiple depdendencies to the operation.
	func addDependencies(_ dependencies: [Operation]) {
		for dependency in dependencies {
			addDependency(dependency)
		}
	}
}

private extension NSLock {
	func withCriticalScope<T>(_ block: (Void) -> T) -> T {
		lock()
		let value = block()
		unlock()
		return value
	}
}

// MARK: - Adapter Alert -> AsyncBlockOperation

extension AsyncBlockOperation {
	convenience init(_ alert: Alert) {
		self.init { alert.handlerClosure($0) }
		self.delayBefore   = alert.beforeDelay
		self.delayAfter    = alert.afterDelay
		self.queuePriority = alert.priority
	}
}

// MARK: - Convenience Alert + AlertDispatcher

extension Alert {
	
	/// dispatch alert with alert dispatch rules
	/// enqueue() if alert dispatchable otherwise present()
	func dispatch(_ completion: (() -> Void)? = nil) {
		AlertDispatcher.dispatch(alert: self.addCompletion { completion?() })
	}
	
	/// present alert now if alert queue is empty
	/// otherwise alert will be ignored
	func present(_ completion: (() -> Void)? = nil) {
		AlertDispatcher.dispatch(alert: self.dispatched(false).addCompletion { completion?() })
	}
	
	/// send alert to alert queue 
	/// will be dispatched guaranteed
	func enqueue(_ completion: (() -> Void)? = nil) {
		AlertDispatcher.dispatch(alert: self.dispatched().addCompletion { completion?() })
	}
}



















