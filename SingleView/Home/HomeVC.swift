//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import APExtensions
import RealmSwift
import UIKit

final class HomeVC: UIViewController, InstantiatableFromStoryboard {
    
    // ******************************* MARK: - @IBOutlets
    
    @IBOutlet fileprivate var textLabel: UILabel!
    @IBOutlet fileprivate var realmLabel: UILabel!
    
    // ******************************* MARK: - Private Properties
    
    fileprivate let realmQueue = DispatchQueue(label: "realm", qos: .userInteractive)
    fileprivate let computeQueue = DispatchQueue(label: "compute", qos: .userInteractive)
    fileprivate let app = App(id: "realmsandbox-grpmo")
    fileprivate var realm: Realm!
    fileprivate var token: NotificationToken!
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        app.syncManager.logger = { logLevel, message in
            switch logLevel {
            case .fatal: print("SyncManager fatal error: \(message)")
            case .error: print("SyncManager error: \(message)")
            case .warn: print("[Warn] \(message)")
            case .info: print("[Info] \(message)")
            case .detail: print("[Detail] \(message)")
            case .debug: print("[Debug] \(message)")
            case .trace: print("[Trace] \(message)")
            case .off: print("[Off] \(message)")
            case .all: print("[All] \(message)")
            }
        }
        
        app.syncManager.logLevel = .all
        
        app.login(credentials: .anonymous) { [self] result in
            switch result {
            case .failure(let error):
                print("Realm login failed: \(error)")
                
            case .success(let user):
                print("Realm login success with user ID '\(user.id)'")
                
                var configuration = user.configuration(partitionValue: "P")
                configuration.objectTypes = [
                    TextRealmModel.self
                ]
                
                Realm.asyncOpen(configuration: configuration, callbackQueue: realmQueue) { result in
                    switch result {
                    case .failure(let error):
                        print("Failed to open realm: \(error)")
                        
                    case .success(let realm):
                        print("Realm async open success")
                        self.realm = realm
                        
                        realmQueue.async { [self] in
                            token = realm.objects(TextRealmModel.self).observe(on: realmQueue, { changeset in
                                switch changeset {
                                    
                                case .initial(let results):
                                    let text = results.first?.text
                                    print("Initial text set: \(text ?? "nil")")
                                    DispatchQueue.main.async {
                                        textLabel.text = "Local: \(text ?? "nil")"
                                        realmLabel.text = "Realm: \(text ?? "nil")"
                                    }
                                    
                                case .update(let results, _, _, _):
                                    let text = results.first?.text
                                    print("Update text set: \(text ?? "nil")")
                                    DispatchQueue.main.async {
                                        realmLabel.text = "Realm: \(text ?? "nil")"
                                    }
                                    
                                case .error(let error):
                                    print("Realm observe error: \(error)")
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    @IBAction fileprivate func onGenerateTap(_ sender: Any) {
        let text = String.random(length: 10)
        textLabel.text = "Local: \(text)"
        let value = AnyBSON(text)
        
        app.currentUser?.functions.updateTexts([value]) { result, error in
            if let error = error {
                print("Function call error: \(error)")
            } else {
                print("Function call success")
            }
        }
    }
    
    @IBAction fileprivate func onForceRefreshTap(_ sender: Any) {
        realmQueue.async { [self] in
            realm.refresh()
        }
    }
}

final class TextRealmModel: Object {
    @objc dynamic var _id = ObjectId.generate()
    @objc dynamic var _p = "P"
    @objc dynamic var text: String = ""
    
    override static func primaryKey() -> String? { "_id" }
}
