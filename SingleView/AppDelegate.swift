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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        _ = DividendsModel.self
        
        // For some reason it might crash only after dispatch is done
        DispatchQueue.main.async {
            _ = DividendsModel.self
        }
        
        // Just one more to be sure
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            _ = DividendsModel.self
            print("SUCCESS")
        }
        
        return true
    }
}

// That's the core cause
public extension DividendsModel {
    override var description: String { "" }
}
