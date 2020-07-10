//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import Alamofire
import APExtensions
import BaseClasses
import UIKit
//import RxSwift
//import RxUtils

final class HomeVC: UIViewController {
    
    // ******************************* MARK: - Private Properties
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cleanup()
        
        var labels = getLabels()
        let date1 = Date()
        labels.forEach { $0.sizeToFit() }
        print("******** sizeToFit", Date().timeIntervalSince(date1))
        
        labels = getLabels()
        labels.forEach { view.addSubview($0) }
        labels.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        let date5 = Date()
        view.layoutIfNeeded()
        print("******** layout view constraints", Date().timeIntervalSince(date5))
        cleanup()
        
        labels = getLabels()
        labels.forEach { view.addSubview($0) }
        labels.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        let date6 = Date()
        labels.forEach { $0.sizeToFit() }
        view.layoutIfNeeded()
        print("******** layout each inside constraints", Date().timeIntervalSince(date6))
        cleanup()
    }
    
    private func getLabels() -> [UILabel] {
        let labels = stride(from: 0, to: 5000, by: 1)
            .map { _ in UILabel() }
        
        labels.forEach {
            $0.text = "text"
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin]
        }
        
        return labels
    }
    
    private func cleanup() {
        view.subviews.forEach { $0.removeFromSuperview() }
        view.layoutIfNeeded()
    }
}

// ******************************* MARK: - InstantiatableFromStoryboard

extension HomeVC: InstantiatableFromStoryboard {}
