//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit
import RxSwift

final class HomeVC: UIViewController {
    
    // ******************************* MARK: - @IBOutlets
    
    // ******************************* MARK: - Private Properties
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        while true {
            let disposeBag = DisposeBag()
            let uuid = UUID().uuidString
            
            let scheduler1 = SerialDispatchQueueScheduler(queue: DispatchQueue.global(qos: .default),
                                                          internalSerialQueueName: "RxSwift-Test-1-\(uuid)")
            
            let scheduler2 = SerialDispatchQueueScheduler(queue: DispatchQueue.global(qos: .default),
                                                          internalSerialQueueName: "RxSwift-Test-2-\(uuid)")
            
            Observable.just(1)
                .observeOn(scheduler2)
                .debug("scheduler2 - \(uuid)")
                .do(onNext: { [weak disposeBag] _ in
                    if disposeBag == nil {
                        print("Operation executed after disposal   - \(uuid)")
                        fatalError("Please put a breakpoint on that line or install an exception breakpoint")
                    }
                })
                .subscribeOn(scheduler2)
                .observeOn(scheduler1)
                .debug("scheduler1 - \(uuid)")
                .subscribeOn(scheduler1)
                .subscribe()
                .disposed(by: disposeBag)
        }
    }
}
