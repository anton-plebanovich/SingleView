//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import RealmSwift
import UIKit

final class HomeVC: UIViewController {
    
    // ******************************* MARK: - @IBOutlets
    
    // ******************************* MARK: - Private Properties
    
    let queue = DispatchQueue(label: "HomeVC", qos: .background)
    var token: NotificationToken!

    // ******************************* MARK: - Initialization and Setup
    
    // ******************************* MARK: - UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        queue.async { [self] in
            let realm = try! Realm(configuration: .defaultConfiguration, queue: queue)
            token = realm.objects(MyObject.self).observe(on: queue, { result in
                switch result {
                case .initial: break
                case .update(_, let deletions, let insertions, let modifications):
                    print("\(deletions)-\(insertions)-\(modifications)")
                    
                case .error(let error):
                    fatalError("\(error)")
                }
            })
            
            queue.async {
                let realm = try! Realm(configuration: .defaultConfiguration, queue: queue)
                try! realm.write {
                    realm.add(MyObject())
                }
            }
        }
    }
    
    @IBAction fileprivate func onTap(_ sender: Any) {
        let realm = try! Realm(configuration: .defaultConfiguration)
        try! realm.write {
            realm.add(MyObject())
        }
    }
}

final class MyObject: Object {
    @objc dynamic var message: String = ""
}
