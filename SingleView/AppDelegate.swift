//
//  AppDelegate.swift
//  SingleView
//
//  Created by Anton Plebanovich on 6/20/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import DivtrackerCommon
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    fileprivate let queue = DispatchQueue(label: "AppDelegate")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        stride(from: 0.0, to: 1000, by: 1).forEach { i in
            queue.asyncAfter(deadline: .now() + i / 10) {
                print("Starting: \(i)")
                
                let pm = Model()
                pm._freeze()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    _ = pm
                    print("Finished: \(i)")
                }
            }
        }
        
        return true
    }
}
