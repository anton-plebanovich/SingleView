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
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
            
            realm.add(TextRealmModel())
        }
        
        let obj: TextRealmModel = realm.objects(TextRealmModel.self).first!
        let duplicate = obj.duplicate()
        
        duplicate.text = "asd"
        try! realm.write {
            realm.add(duplicate)
        }
        
        let objs = realm.objects(TextRealmModel.self)
        
    }
}

final class TextRealmModel: Object {
    @objc dynamic var _id = ObjectId.generate()
    @objc dynamic var _p = "P"
    @objc dynamic var text: String = ""
    
    override static func primaryKey() -> String? { "_id" }
}

protocol DetachableObject: AnyObject {
    func detached() -> Self
    func duplicate() -> Self
}

protocol RealmDetachableObject: DetachableObject & NSObject {
    var objectSchema: RealmSwift.ObjectSchema { get }
}

extension RealmDetachableObject {
    /// Returns unmanaged object
    func detached() -> Self {
        let detached = type(of: self).init()
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else { continue }
            if property.isArray == true {
                // Realm List property support
                if let detachable = value as? DetachableObject {
                    detached.setValue(detachable.detached(), forKey: property.name)
                } else {
                    // logError
                }
                
            } else if property.type == .object {
                // Realm Object property support
                if let detachable = value as? DetachableObject {
                    detached.setValue(detachable.detached(), forKey: property.name)
                } else {
                    // logError
                }
                
            } else {
                detached.setValue(value, forKey: property.name)
            }
        }
        return detached
    }
    
    func duplicate() -> Self {
        let selfType = type(of: self)
        let duplicate = selfType.init()
        let primaryKey = (selfType as? Object.Type)?.primaryKey()
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else { continue }
            if property.isArray == true {
                // Realm List property support
                if let detachable = value as? DetachableObject {
                    duplicate.setValue(detachable.duplicate(), forKey: property.name)
                } else {
                    // logError
                    print("error")
                }
                
            } else if property.type == .object {
                // Realm Object property support
                if let detachable = value as? DetachableObject {
                    duplicate.setValue(detachable.duplicate(), forKey: property.name)
                } else {
                    // logError
                    print("error")
                }
                
            } else {
                // Primary key change
                if property.name == primaryKey {
                    if value is ObjectId {
                        duplicate.setValue(ObjectId.generate(), forKey: property.name)
                    } else if value is String {
                        duplicate.setValue(UUID().uuidString, forKey: property.name)
                    } else {
                        // logError
                        print("error")
                    }
                    
                } else {
                    duplicate.setValue(value, forKey: property.name)
                }
            }
        }
        return duplicate
    }
}

extension Object: RealmDetachableObject {}
extension EmbeddedObject: RealmDetachableObject {}

extension List: DetachableObject {
    
    /// Returns list of detached objects
    func detached() -> Self {
        let result = Self()
        
        forEach {
            if let detachable = $0 as? DetachableObject {
                let detached = detachable.detached() as! Element
                result.append(detached)
            } else {
                result.append($0) // Primtives are pass by value; don't need to recreate
            }
        }
        
        return result
    }
    
    func duplicate() -> Self {
        return detached()
    }
    
    /// Returns array of detached objects
    func toArray() -> [Element] {
        Array(detached())
    }
}
