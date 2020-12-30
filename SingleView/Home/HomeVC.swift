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
    
    let mainScheduler = MainScheduler.instance
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async { [self] in
            while true {
                let disposeBag = DisposeBag()
                let uuid = UUID().uuidString
                let scheduler = SerialDispatchQueueScheduler(queue: DispatchQueue.global(qos: .default),
                                                             internalSerialQueueName: "RxSwift-Test-\(uuid)")
                
                Observable.just(1)
                    .observeOn(mainScheduler)
                    .debug("mainScheduler - \(uuid)")
                    .do(onNext: { [weak disposeBag] _ in print(disposeBag!) })
                    .subscribeOn(mainScheduler)
                    .observeOn(scheduler)
                    .subscribeOn(scheduler)
                    .debug("scheduler - \(uuid)")
                    .subscribe()
                    .disposed(by: disposeBag)
            }
        }
    }
}
