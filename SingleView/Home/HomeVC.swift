//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import APExtensions
import RealmSwift
import UIKit

final class HomeVC: UIViewController, InstantiatableFromStoryboard {
    
    // ******************************* MARK: - @IBOutlets
    
    @IBOutlet fileprivate var textLabel: UILabel!
    @IBOutlet fileprivate var realmLabel: UILabel!
    
    let lock = NSLock()
    let recursiveLock = NSRecursiveLock()
    
    // ******************************* MARK: - Private Properties
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var time1: TimeInterval = 0
        stride(from: 0, to: 10000000, by: 1).forEach { _ in
            let date1 = Date()
            recursiveLock.lock()
            recursiveLock.unlock()
            
            let delta = Date().timeIntervalSince(date1)
            time1 += delta
        }
        print("******** recursive %f", time1)
        
        var time2: TimeInterval = 0
        stride(from: 0, to: 10000000, by: 1).forEach { _ in
            let date2 = Date()
            lock.lock()
            lock.unlock()
            
            let delta = Date().timeIntervalSince(date2)
            time2 += delta
        }
        print("******** lock %f", time2)
    }
}
