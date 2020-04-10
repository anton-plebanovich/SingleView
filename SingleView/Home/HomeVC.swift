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
//import RxSwift
//import RxUtils

final class HomeVC: UIViewController {
    
    // ******************************* MARK: - Private Properties
    
    let manager = NetworkReachabilityManager()
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager?.startListening(onUpdatePerforming: { status in
            print(status)
            print(self.manager?.flags)
        })
    }
}

// ******************************* MARK: - InstantiatableFromStoryboard

extension HomeVC: InstantiatableFromStoryboard {}
