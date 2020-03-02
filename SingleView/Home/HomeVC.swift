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
    
    private lazy var session: Session = {
        let session = Session(interceptor: self)
        
        return session
    }()
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = session.request("https://tut.by").responseString { response in
            print(try? response.result.get())
        }
        
        g.asyncMain(1) {
            print("cancel")
            request.cancel()
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
