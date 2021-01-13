//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit
import RealmSwift

final class HomeVC: UIViewController {
    
    // ******************************* MARK: - @IBOutlets
    
    // ******************************* MARK: - Private Properties
    
    let scheduler1 = DispatchQueue.global(qos: .default)
    let scheduler2 = DispatchQueue.global(qos: .default)
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stride(from: 0, to: 20, by: 1).forEach { delay in
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
                print("\(delay)")
                addAndDeleteObjects1()
                addAndDeleteObjects2()
            }
        }
    }
    
    private func addAndDeleteObjects1() {
        var objects: [Object1] = []
        scheduler1.async { [self] in
            objects = generateObjects1()
            let realm = try! Realm()
            try! realm.write {
                realm.add(objects)
            }
        }
        
        let random1 = Double.random(in: 0...0.2)
        scheduler1.asyncAfter(deadline: .now() + 0.49 + random1) {
            let realm = try! Realm()
            try! realm.write {
                let objects = realm.objects(Object1.self)
                realm.delete(objects)
            }
        }
        
        let random2 = Double.random(in: 0...0.2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.49 + random2) {
            _ = objects
        }
    }
    
    private func addAndDeleteObjects2() {
        var objects: [Object2] = []
        scheduler2.async { [self] in
            objects = generateObjects2()
            let realm = try! Realm()
            try! realm.write {
                realm.add(objects)
            }
        }
        
        let random1 = Double.random(in: 0...0.2)
        scheduler1.asyncAfter(deadline: .now() + 0.49 + random1) {
            let realm = try! Realm()
            try! realm.write {
                let objects = realm.objects(Object2.self)
                realm.delete(objects)
            }
            
            _ = objects
        }
        
        let random = Double.random(in: 0...0.2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.49 + random) {
            _ = objects
        }
    }
    
    private func generateObjects1() -> [Object1] {
        stride(from: 0, to: 1000, by: 1).map { _ in Object1() }
    }
    
    private func generateObjects2() -> [Object2] {
        stride(from: 0, to: 1000, by: 1).map { _ in Object2() }
    }
}

final class Object1: Object {
    @objc dynamic var id: String = UUID().uuidString
}

final class Object2: Object {
    @objc dynamic var id: String = UUID().uuidString
}
