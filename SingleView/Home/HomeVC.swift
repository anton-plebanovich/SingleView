//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import Alamofire
import APExtensions
import BaseClasses
import UIKit
import RxSwift
import RxUtils

final class HomeVC: UIViewController {
    
    // ******************************* MARK: - Private Properties
    
    private let scheduler = SerialDispatchQueueScheduler(queue: DispatchQueue.global(qos: .default), internalSerialQueueName: "identifier")
    private let disposeBag = DisposeBag()
    
    var arr: [Int: Single<Int>] = [:]
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
let observable = Observable<Int>
    .create { observer in
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            observer.onNext(1)
            observer.onCompleted()
        }
        
        return Disposables.create()
    }
    .debug("debug")
    .share(replay: 1, scope: .forever)
    .take(1)

_ = observable.subscribe()

DispatchQueue.main.asyncAfter(deadline: .now()) {
    _ = observable.subscribe()
}
    }
}

// ******************************* MARK: - InstantiatableFromStoryboard

extension HomeVC: InstantiatableFromStoryboard {}

// MARK: - RequestRetrier

extension HomeVC: RequestInterceptor {
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry \(error.localizedDescription)")
        completion(.retryWithDelay(5))
    }
}
