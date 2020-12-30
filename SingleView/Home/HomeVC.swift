//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

final class HomeVC: UIViewController {
    
    // ******************************* MARK: - @IBOutlets
    
    // ******************************* MARK: - Private Properties
    
    let mainScheduler = MainScheduler.instance
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async { [self] in
            while true {
                var disposeBag: DisposeBag? = DisposeBag()
                let uuid = UUID().uuidString
                let scheduler = SerialDispatchQueueScheduler(queue: DispatchQueue.global(qos: .default),
                                                             internalSerialQueueName: "RxSwift-Test-\(uuid)")
                
                let relay = BehaviorRelay(value: 1)
                
                relay
                    .observeOn(mainScheduler)
                    .debug("mainScheduler - \(uuid)")
                    .do(onNext: { [weak disposeBag] _ in print(disposeBag!) })
                    .subscribeOn(mainScheduler)
                    .observeOn(scheduler)
                    .subscribeOn(scheduler)
                    .debug("scheduler - \(uuid)")
                    .subscribe()
                    .disposed(by: disposeBag!)
                
                disposeBag = nil
                relay.accept(2)
            }
        }
    }
}
