//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import CocoaLumberjack
import UIKit

final class HomeVC: UIViewController {
    
    // ******************************* MARK: - @IBOutlets
    
    // ******************************* MARK: - Private Properties

    // ******************************* MARK: - Initialization and Setup
    
    // ******************************* MARK: - UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DDLog.sharedInstance.add(TextLogger())
        
        let logMessage = DDLogMessage(message: "viewDidLoad",
                                      level: .debug,
                                      flag: .debug,
                                      context: 0,
                                      file: #file,
                                      function: #function,
                                      line: #line,
                                      tag: nil,
                                      options: [.dontCopyMessage],
                                      timestamp: Date())
        
        DDLog.sharedInstance.log(asynchronous: false, message: logMessage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

/// Abstract base class inherited from DDAbstractLogger that represents text logger.
/// Override process(message:) in child classes
open class TextLogger: DDAbstractLogger {
    
    required public override init() {
        super.init()
    }
    
    // ******************************* MARK: - DDLogger Overrides
    
    override open func log(message logMessage: DDLogMessage) {
        
        // Deadlock
        let logMessage = DDLogMessage(message: "Deadlock",
                                      level: .error,
                                      flag: .error,
                                      context: 0,
                                      file: #file,
                                      function: #function,
                                      line: #line,
                                      tag: nil,
                                      options: [.dontCopyMessage],
                                      timestamp: Date())
        
        DDLog.sharedInstance.log(asynchronous: false, message: logMessage)
        
        print(logMessage)
    }
}
