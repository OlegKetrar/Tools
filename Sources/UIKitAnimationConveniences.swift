//
//  UIKitAnimationConveniences.swift
//  Tools
//
//  Created by Oleg Ketrar on 2/10/17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import UIKit

// MARK: - UIView Animation Convenience

struct Animation {

    fileprivate enum AnimationType {
        case `default`
        case spring(damping: CGFloat, initialVelocity: CGFloat)
        case keyFrame(options: UIViewKeyframeAnimationOptions)
    }

    fileprivate let type: AnimationType

    var delay: TimeInterval    = 0
    var duration: TimeInterval = 0.33
    var options: UIViewAnimationOptions = []

    fileprivate var animation  = Block<Void>()
    fileprivate var completion = Block<Void>()

    private init(type: AnimationType) {
        self.type = type
    }

    // MARK: - Creation

    init(duration: TimeInterval = 0.33) {
        self.init(type: .default)
        self.duration = duration
    }

    static func spring(damping: CGFloat, initialVelocity velocity: CGFloat) -> Animation {
        return Animation(type: .spring(damping: damping, initialVelocity: velocity))
    }

    static func keyFrame(options: UIViewKeyframeAnimationOptions) -> Animation {
        return Animation(type: .keyFrame(options: options))
    }
}

// MARK: Animate

extension Animation {

    // MARK: Append closures

    func addAnimation(_ closure: @escaping () -> Void) -> Animation {
        var copy = self
        copy.animation.add(closure)
        return copy
    }

    func addCompletion(_ closure: @escaping () -> Void) -> Animation {
        var copy = self
        copy.completion.add(closure)
        return copy
    }

    // MARK: Perform

    func animate(_ closure: @escaping () -> Void, completion: @escaping () -> Void) {
        addAnimation(closure).addCompletion(completion).perform()
    }

    func animate(_ closure: @escaping () -> Void) {
        addAnimation(closure).perform()
    }

    func performWithCompletion(_ closure: @escaping () -> Void) {
        addCompletion(closure).perform()
    }

    private func perform() {

        // negative duration recognized as zero
        guard duration > 0 else {
            return DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(delay * 1000))) {
                self.animation.execute()
                self.completion.execute()
            }
        }

        // duration greater than zero
        switch type {

        case .default:
            UIView.animate(withDuration: duration,
                           delay: delay,
                           options: options,
                           animations: animation.execute,
                           completion: { _ in self.completion.execute() })

        case .spring(damping: let damping, initialVelocity: let velocity):
            UIView.animate(withDuration: duration,
                           delay: delay,
                           usingSpringWithDamping: damping,
                           initialSpringVelocity: velocity,
                           options: options,
                           animations: animation.execute,
                           completion: { _ in self.completion.execute() })

        case .keyFrame(options: let keyframeOptions):
            UIView.animateKeyframes(withDuration: duration,
                                    delay: delay,
                                    options: keyframeOptions,
                                    animations: animation.execute,
                                    completion: { _ in self.completion.execute() })
        }
    }

    // MARK: Convenience non-mutating methods

    func setDelay(_ newDelay: TimeInterval) -> Animation {
        var copy = self
        copy.delay = newDelay
        return copy
    }
    
    func setDuration(_ newDuration: TimeInterval) -> Animation {
        var copy = self
        copy.duration = newDuration
        return copy
    }
    
    func setOptions(_ newOptions: UIViewAnimationOptions) -> Animation {
        var copy = self
        copy.options = newOptions
        return copy
    }
}

struct Block<T> {
    var execute: (T) -> Void

    init(_ closure: @escaping (T) -> Void = { _ in }) {
        execute = closure
    }

    mutating func add(_ closure: @escaping (T) -> Void) {
        let oldExecute = execute
        execute = { oldExecute($0); closure($0) }
    }

    func adding(_ closure: @escaping (T) -> Void) -> Block {
        var copy = self
        copy.add(closure)
        return copy
    }
}















