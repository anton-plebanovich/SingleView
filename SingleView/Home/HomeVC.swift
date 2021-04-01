//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit
import KeychainAccess

final class HomeVC: UIViewController {
    
    // ******************************* MARK: - @IBOutlets
    
    // ******************************* MARK: - Private Properties
    
    let keychain = Keychain(service: "my_keychain")
        .accessibility(.afterFirstUnlockThisDeviceOnly)
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            print(try keychain.getData("my_key") != nil)
        } catch {
            print(error)
        }
        
        do {
            try keychain.set(Data(), key: "my_key")
        } catch {
            print(error)
        }
    }
}
