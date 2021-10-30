//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import APExtensions
import UIKit

// ******************************* MARK: - Equatable

extension Sequence where Element: Equatable {
    
    /// Helper method to filter out duplicates
    @inlinable func distinct() -> [Element] {
        return distinct { $0 == $1 }
    }
}

extension Sequence where Element: Hashable {
    
    /// Helper method to filter out duplicates
    @inlinable func unique() -> [Element] {
        return Array(Set(self))
    }
}

// ******************************* MARK: - Scripting

extension Sequence {
    /// Helper method to filter out duplicates. Element will be filtered out if closure return true.
    @inlinable func distinct(_ exclude: (_ lhs: Element, _ rhs: Element) throws -> Bool) rethrows -> [Element] {
        var results = [Element]()
        
        try forEach { element in
            let exclude = try results.contains {
                return try exclude(element, $0)
            }
            if !exclude {
                results.append(element)
            }
        }
        
        return results
    }
}


final class HomeVC: UIViewController, InstantiatableFromStoryboard {
    
    // ******************************* MARK: - @IBOutlets
    
    @IBOutlet fileprivate var textLabel: UILabel!
    @IBOutlet fileprivate var realmLabel: UILabel!
    
    // ******************************* MARK: - Private Properties

    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let array: [Int] = stride(from: 0, to: 10000, by: 1)
            .map { _ in Int.random(in: 0...10000) }
        
        let array2 = array
        let array3 = array
        
        let date2 = Date()
        _ = array2.distinct()
        print("********2 %f", Date().timeIntervalSince(date2))
        
        let date1 = Date()
        _ = array.filterDuplicates()
        print("********1 %f", Date().timeIntervalSince(date1))
        
        let date3 = Date()
        _ = array3.unique()
        print("********3 %f", Date().timeIntervalSince(date3))
    }
}

extension Int {
    var asSelf: Int {
        self
    }
}
