//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import RealmSwift
import RxRealm
import RxSwift
import RxUtils
import UIKit

final class HomeVC: UIViewController {
    
    // ******************************* MARK: - @IBOutlets
    
    // ******************************* MARK: - Private Properties
    
    let queue = DispatchQueue(label: "HomeVC", qos: .background)

    // ******************************* MARK: - Initialization and Setup
    
    // ******************************* MARK: - UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        queue.async { [self] in
            let realm = try! Realm(configuration: .defaultConfiguration, queue: queue)
            let result = realm.objects(MyObject.self)
            _ = Observable.array(from: result, synchronousStart: false, on: queue)
                .subscribeOnNext { objects in
                    print("1 | Received objects: \(!objects.isEmpty)")
                    let realm = try! Realm(configuration: .defaultConfiguration, queue: queue)
                    try! realm.write {
                        print("1 | deleting all objects")
                        realm.deleteAll()
                    }
                }
            
            _ = Observable.array(from: result, synchronousStart: false, on: queue)
                .subscribeOnNext { objects in
                    if let object = objects.first {
                        print("2 | isInvalidated: \(object.isInvalidated)")
                    } else {
                        print("2 | no objects")
                    }
                }
            
            queue.asyncAfter(deadline: .now() + 1) {
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
            realm.deleteAll()
            realm.add(MyObject())
        }
    }
}

final class MyObject: Object {
    @objc dynamic var message: String = ""
}
