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
    
    // ******************************* MARK: - Private Properties
    
    fileprivate let app = App(id: "realmsandbox-grpmo")
    fileprivate var token: NotificationToken!
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupApp(app: app)
        
        // Please set breakpoint to RLMSyncSession.mm:64 to be able to investigate app state
        login(app: app) { [self] user in
            openRealm(user: user) { realm in
                // Capture token and release `realm`
                let token = realm.syncSession?.addProgressNotification(for: .download, mode: .reportIndefinitely) { _ in }
                DispatchQueue.main.async {
                    // Invalidate and release `token` to observe error message
                    token?.invalidate()
                }
            }
        }
    }
    
    fileprivate func setupApp(app: App) {
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
    }
    
    fileprivate func login(app: App, completion: @escaping (User) -> Void) {
        app.login(credentials: .anonymous) { result in
            switch result {
            case .failure(let error):
                fatalError("Realm login failed: \(error)")
                
            case .success(let user):
                print("Realm login success with user ID '\(user.id)'")
                completion(user)
            }
        }
    }
    
    fileprivate func openRealm(user: User, completion: @escaping (Realm) -> Void) {
        var configuration = user.configuration(partitionValue: "P")
        configuration.objectTypes = [
            TextRealmModel.self
        ]
        
        Realm.asyncOpen(configuration: configuration) { result in
            switch result {
            case .failure(let error):
                print("Failed to open realm: \(error)")
                _ = try! Realm.deleteFiles(for: configuration)
                self.openRealm(user: user, completion: completion)
                
            case .success(let realm):
                print("Realm async open success")
                completion(realm)
            }
        }
    }
}

final class TextRealmModel: Object {
    @objc dynamic var _id = ObjectId.generate()
    @objc dynamic var _p = "P"
    @objc dynamic var text: String = ""
    
    override static func primaryKey() -> String? { "_id" }
}
