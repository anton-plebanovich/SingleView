//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftExt

final class HomeVC: UIViewController {
    
    // ******************************* MARK: - @IBOutlets
    
    // ******************************* MARK: - Private Properties
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = Observable<Int>.error(NSError(domain: "", code: 0))
            .debug()
            .retry(.immediate(maxCount: 1))
            .catchErrorJustComplete()
            .subscribe()
    }
}
