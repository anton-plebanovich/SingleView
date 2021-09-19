//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import APExtensions
import UIKit
//import RxSwift
//import RxRelay
//import RxCocoa
import CoreLocation
//import RxUtils

final class HomeVC: UIViewController, InstantiatableFromStoryboard {
    
    // ******************************* MARK: - @IBOutlets
    
    // ******************************* MARK: - Private Properties
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        print(coordinate.adjusted(bearing: 0, distance: 1).latitude.asString(precition: 7))
    }
}

fileprivate extension CLLocationCoordinate2D {
    
    /// Adjusts coordinate value using parameters.
    /// It assumes that the Earth is a circle and so not so precise but enough for our needs.
    ///
    /// - [Stack Overflow](https://stackoverflow.com/questions/7278094/moving-a-cllocation-by-x-meters)
    /// - parameter bearing: Adjust bearing (direction) in degrees. E.g. value of 0 means North and 180 means South.
    /// - parameter distance: Adjust distance in meters.
    func adjusted(bearing: Double, distance: Double) -> CLLocationCoordinate2D {
        let distRadians = distance / 6372797.6 // earth radius in meters
        
        let lat1 = latitude * .pi / 180
        let lon1 = longitude * .pi / 180
        
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / .pi, longitude: lon2 * 180 / .pi)
    }
}
