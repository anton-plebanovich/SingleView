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
    
    private lazy var firstView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return view
    }()
    
    private lazy var secondView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return view
    }()
    
    private var firstViewWidth: NSLayoutConstraint!
    private var secondViewWidth: NSLayoutConstraint!
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(firstView)
        view.addSubview(secondView)
        
        firstView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        firstView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        firstViewWidth = firstView.widthAnchor.constraint(equalToConstant: 0)
        firstViewWidth.isActive = true
        
        secondView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        secondView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        secondViewWidth = secondView.widthAnchor.constraint(equalToConstant: 0)
        secondViewWidth.isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        g.asyncMain(1) {
            g.animate(2, options: []) {
                self.firstViewWidth.constant = self.view.width
                self.view.layoutIfNeeded()
            }
            
            g.asyncMain(1) {
                g.animate(2, options: []) {
                    self.firstViewWidth.constant = 0
                    self.secondViewWidth.constant = self.view.width
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

// ******************************* MARK: - InstantiatableFromStoryboard

extension HomeVC: InstantiatableFromStoryboard {}
