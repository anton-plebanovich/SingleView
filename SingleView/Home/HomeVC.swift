//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import Alamofire
import UIKit

final class HomeVC: UIViewController {
    
    // ******************************* MARK: - @IBOutlets
    
    // ******************************* MARK: - Private Properties

    // ******************************* MARK: - Initialization and Setup
    
    // ******************************* MARK: - UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventMonitor = ClosureEventMonitor()
        eventMonitor.requestDidParseResponse = { _, _ in print("requestDidParseResponse") }
        
        let session = Session(eventMonitors: [eventMonitor])
        session.request("https://google.com")
            .response { _ in
                print("1")
            }
            .response { _ in
                print("2")
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}
