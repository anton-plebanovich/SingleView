//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit
import Alamofire

final class HomeVC: UIViewController {
    
    // ******************************* MARK: - @IBOutlets
    
    // ******************************* MARK: - Private Properties
    
    private lazy var configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        
        return configuration
    }()
    
    private lazy var session = Session(configuration: configuration,
                          startRequestsImmediately: true,
                          interceptor: ErrorsRequestRetrier())
    
    let url = URL(string: "https://google.com")!
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startPerformingRequests()
    }
    
    fileprivate func startPerformingRequests() {
        
        NSLog("Start")
        let dataRequest = session.request(url).response { response in
            if let error = response.error {
                if error.isExplicitlyCancelledError {
                    NSLog("Cancelled")
                } else {
                    fatalError("Received unexpected error - \(response.error)")
                }
                
            } else {
                NSLog("Success")
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dataRequest.cancel()
            self.startPerformingRequests()
        }
    }
}

final class ErrorsRequestRetrier: RequestAdapter, RequestInterceptor {
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        if error.asAFError?.isExplicitlyCancelledError == true {
            NSLog("Do not retry")
            completion(.doNotRetry)
        } else {
            NSLog("Retry")
            completion(.retryWithDelay(1))
        }
    }
}
