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

final class HomeVC: UIViewController {
    
    // ******************************* MARK: - Private Properties
    
    private lazy var sm: SessionManager = {
        let sm = SessionManager()
        sm.retrier = self
        
        return sm
    }()
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = sm.request("https://tut.by").responseString { response in
            print(response.result.value.description)
        }
        
        g.asyncMain(1) {
            request.cancel()
        }
    }
}

// ******************************* MARK: - InstantiatableFromStoryboard

extension HomeVC: InstantiatableFromStoryboard {}

// MARK: - RequestRetrier

extension HomeVC: RequestRetrier {
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        completion(true, 5)
    }
}
