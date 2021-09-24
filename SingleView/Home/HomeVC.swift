//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import APExtensions
import RealmSwift
import RxCocoa
import RxRelay
import RxSwift
import RxUtils
import UIKit

final class HomeVC: UIViewController, InstantiatableFromStoryboard {
    
    // ******************************* MARK: - @IBOutlets
    
    @IBOutlet fileprivate var textLabel: UILabel!
    @IBOutlet fileprivate var realmLabel: UILabel!
    
    // ******************************* MARK: - Private Properties
    
    fileprivate let realmQueue = DispatchQueue(label: "realm", qos: .userInteractive)
    fileprivate let computeQueue = DispatchQueue(label: "compute", qos: .userInteractive)
    fileprivate var realm: Realm!
    fileprivate var token: NotificationToken!
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realmQueue.async { [self] in
            realm = try! Realm(queue: realmQueue)
            
            let myObject = MyObject()
            try! realm.write {
                realm.deleteAll()
                realm.add(myObject)
            }
            
            token = realm.objects(MyObject.self).observe(on: realmQueue, { changeset in
                switch changeset {
                    
                case .initial(let results):
                    let text = results.first!.text
                    DispatchQueue.main.async {
                        realmLabel.text = text
                    }
                    
                case .update(let results, _, _, _):
                    let text = results.first!.text
                    DispatchQueue.main.async {
                        realmLabel.text = text
                    }
                    
                case .error(_):
                    break
                }
            })
        }
    }
    
    @IBAction fileprivate func onGenerateTap(_ sender: Any) {
        let text = String.random(length: 10)
        textLabel.text = text
        
        realmQueue.async { [self] in
            try! realm.write {
                realm.objects(MyObject.self).first!.text = text
            }
        }
    }
}

final class MyObject: Object {
    @objc dynamic var text: String = ""
}
