//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit
import Alamofire

private var g_dataRequest: DataRequest!

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
    
    let url = URL(string: "https://some_non_existing_host_should_be_good_enough.com")!
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("Start")
        g_dataRequest = session.request(url).response { response in
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
    }
}

final class ErrorsRequestRetrier: RequestAdapter, RequestInterceptor {
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        if error.asAFError?.isExplicitlyCancelledError == true {
            NSLog("Do not retry")
            completion(.doNotRetry)
        } else {
            NSLog("Retry")
            completion(.retryWithDelay(10))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                g_dataRequest.cancel()
            }
        }
    }
}
