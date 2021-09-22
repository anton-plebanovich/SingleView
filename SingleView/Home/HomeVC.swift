//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import APExtensions
import RxCocoa
import RxRelay
import RxSwift
import RxUtils
import UIKit

final class HomeVC: UIViewController, InstantiatableFromStoryboard {
    
    // ******************************* MARK: - @IBOutlets
    
    // ******************************* MARK: - Private Properties
    
    fileprivate static let realmQueue = DispatchQueue(label: "RealmManager.realm", qos: .userInteractive)
    fileprivate static let realmScheduler = DispatchQueueScheduler(queue: realmQueue)
    
    fileprivate static let computeQueue = DispatchQueue(label: "RealmManager.compute", qos: .userInteractive)
    fileprivate static let computeScheduler = DispatchQueueScheduler(queue: computeQueue)
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = Observable.just(())
            .flatMapLatest {
                Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: Self.realmScheduler)
                .observe(on: Self.realmScheduler)
                .doOnNext { print("Timer - \($0)") }
            }
            .flatMapThrottle(scheduler: Self.computeScheduler) { i -> Observable<Int> in
                Observable.just(i)
                    .doOnNext { print("Timer - \($0).1") }
                    .doOnNext { _ in sleep(1) }
                    .doOnNext { print("Timer - \($0).2") }
                    .doOnNext { _ in sleep(1) }
                    .doOnNext { print("Timer - \($0).3") }
                    .doOnNext { _ in sleep(1) }
                    .doOnNext { print("Timer - \($0).4") }
            }
            .subscribeOnNext {
                print("Finish - \($0)")
            }
    }
}

extension ObservableConvertibleType {
    
    // TODO:
    func flatMapThrottle<Source: ObservableConvertibleType>(
        scheduler: DispatchQueueScheduler,
        selector: @escaping (Self.Element) throws -> Source
    ) -> Observable<Source.Element> {
        
        var _throttledElement: Element? = nil
        var _executing: Bool = false
        let _lock = NSRecursiveLock()
        let _backgroundQueueKey = DispatchSpecificKey<Void>()
        var _subscribeOnTheSameQueue = false
        
        scheduler.configuration.queue.setSpecific(key: _backgroundQueueKey, value: ())
        
        func executeNext(element: Source.Element) -> Observable<Source.Element> {
            _lock.lock(); defer { _lock.unlock() }
            
            if let throttledElement = _throttledElement {
                return Observable.just(throttledElement)
                    .observe(on: scheduler)
                    .flatMap { try selector($0) }
                    .flatMap { executeNext(element: $0) }
                    .startWith(element)
                
            } else {
                _executing = false
                return .just(element)
            }
        }
        
        return asObservable()
            .flatMap { element -> Observable<Source.Element> in
                _lock.lock(); defer { _lock.unlock() }
                
                if _executing {
                    _throttledElement = element
                    return .empty()
                    
                } else {
                    _executing = true
                    return Observable.just(element)
                        .doOnNext { _ in
                            if DispatchQueue.getSpecific(key: _backgroundQueueKey) != nil {
                                _lock.lock(); defer { _lock.unlock() }
                                _subscribeOnTheSameQueue = true
                            }
                        }
                        .observe(on: scheduler)
                        .flatMap { try selector($0) }
                        .doOnNext { _ in
                            _lock.lock(); defer { _lock.unlock() }
                            if _subscribeOnTheSameQueue {
                                assertionFailure("Events and execution should not happen on the same queue or `flatMapThrottle` won't work.")
                            }
                        }
                        .flatMap { executeNext(element: $0) }
                }
            }
    }
}

// ******************************* MARK: - DispatchQueue Scheduler

/// Abstracts the work that needs to be performed on a specific `dispatch_queue_t`.
///
/// This scheduler is suitable when some work needs to be performed in background.
/// - note: Copy & pasted from the `ConcurrentDispatchQueueScheduler` just to make sure it won't accidenty became concurrent for real.
final class DispatchQueueScheduler: SchedulerType {
    typealias TimeInterval = Foundation.TimeInterval
    typealias Time = Date
    
    var now: Date {
        Date()
    }
    
    let configuration: DispatchQueueConfiguration
    
    /// Constructs new `DispatchQueueScheduler` that wraps `queue`.
    ///
    /// - parameter queue: Target dispatch queue.
    /// - parameter leeway: The amount of time, in nanoseconds, that the system will defer the timer.
    init(queue: DispatchQueue, leeway: DispatchTimeInterval = DispatchTimeInterval.nanoseconds(0)) {
        configuration = DispatchQueueConfiguration(queue: queue, leeway: leeway)
    }
    
    /**
     Schedules an action to be executed immediately.
     
     - parameter state: State passed to the action to be executed.
     - parameter action: Action to be executed.
     - returns: The disposable object used to cancel the scheduled action (best effort).
     */
    final func schedule<StateType>(_ state: StateType, action: @escaping (StateType) -> Disposable) -> Disposable {
        configuration.schedule(state, action: action)
    }
    
    /**
     Schedules an action to be executed.
     
     - parameter state: State passed to the action to be executed.
     - parameter dueTime: Relative time after which to execute the action.
     - parameter action: Action to be executed.
     - returns: The disposable object used to cancel the scheduled action (best effort).
     */
    final func scheduleRelative<StateType>(_ state: StateType, dueTime: RxTimeInterval, action: @escaping (StateType) -> Disposable) -> Disposable {
        configuration.scheduleRelative(state, dueTime: dueTime, action: action)
    }
    
    /**
     Schedules a periodic piece of work.
     
     - parameter state: State passed to the action to be executed.
     - parameter startAfter: Period after which initial work should be run.
     - parameter period: Period for running the work periodically.
     - parameter action: Action to be executed.
     - returns: The disposable object used to cancel the scheduled action (best effort).
     */
    func schedulePeriodic<StateType>(_ state: StateType, startAfter: RxTimeInterval, period: RxTimeInterval, action: @escaping (StateType) -> StateType) -> Disposable {
        configuration.schedulePeriodic(state, startAfter: startAfter, period: period, action: action)
    }
}

/// - note: Copy & pasted from the `RxSwift`.
struct DispatchQueueConfiguration {
    let queue: DispatchQueue
    let leeway: DispatchTimeInterval
}

extension DispatchQueueConfiguration {
    func schedule<StateType>(_ state: StateType, action: @escaping (StateType) -> Disposable) -> Disposable {
        let cancel = SingleAssignmentDisposable()
        
        queue.async {
            if cancel.isDisposed {
                return
            }
            
            cancel.setDisposable(action(state))
        }
        
        return cancel
    }
    
    func scheduleRelative<StateType>(_ state: StateType, dueTime: RxTimeInterval, action: @escaping (StateType) -> Disposable) -> Disposable {
        let deadline = DispatchTime.now() + dueTime
        
        let compositeDisposable = CompositeDisposable()
        
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: deadline, leeway: leeway)
        
        // TODO:
        // This looks horrible, and yes, it is.
        // It looks like Apple has made a conceputal change here, and I'm unsure why.
        // Need more info on this.
        // It looks like just setting timer to fire and not holding a reference to it
        // until deadline causes timer cancellation.
        var timerReference: DispatchSourceTimer? = timer
        let cancelTimer = Disposables.create {
            timerReference?.cancel()
            timerReference = nil
        }
        
        timer.setEventHandler(handler: {
            if compositeDisposable.isDisposed {
                return
            }
            _ = compositeDisposable.insert(action(state))
            cancelTimer.dispose()
        })
        timer.resume()
        
        _ = compositeDisposable.insert(cancelTimer)
        
        return compositeDisposable
    }
    
    func schedulePeriodic<StateType>(_ state: StateType, startAfter: RxTimeInterval, period: RxTimeInterval, action: @escaping (StateType) -> StateType) -> Disposable {
        let initial = DispatchTime.now() + startAfter
        
        var timerState = state
        
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: initial, repeating: period, leeway: leeway)
        
        // TODO:
        // This looks horrible, and yes, it is.
        // It looks like Apple has made a conceputal change here, and I'm unsure why.
        // Need more info on this.
        // It looks like just setting timer to fire and not holding a reference to it
        // until deadline causes timer cancellation.
        var timerReference: DispatchSourceTimer? = timer
        let cancelTimer = Disposables.create {
            timerReference?.cancel()
            timerReference = nil
        }
        
        timer.setEventHandler(handler: {
            if cancelTimer.isDisposed {
                return
            }
            timerState = action(timerState)
        })
        timer.resume()
        
        return cancelTimer
    }
}
