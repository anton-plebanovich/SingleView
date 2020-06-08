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
    
    private lazy var dashLineImageView: UIImageView = {
        // Using image as a background color because there is a bug
        // in a asset catalog that prevents using image with a tile
        // rule when top inset is zero.
        let image = #imageLiteral(resourceName: "ic_dash_line")
        let color = UIColor(patternImage: image)
        
        let dashLineImageView = UIImageView()
        dashLineImageView.translatesAutoresizingMaskIntoConstraints = false
        dashLineImageView.backgroundColor = color
        
        return dashLineImageView
    }()
    
    private var topConstraint: NSLayoutConstraint!
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(dashLineImageView)
        dashLineImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topConstraint = dashLineImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200)
        topConstraint!.isActive = true
        dashLineImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        dashLineImageView.widthAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        g.asyncMain(1) {
            UIView.animate(withDuration: 2) {
                self.topConstraint.constant = 64
                self.dashLineImageView.bounds.origin.y = -136
                self.view.layoutIfNeeded()
            }
        }
    }
}

// ******************************* MARK: - InstantiatableFromStoryboard

extension HomeVC: InstantiatableFromStoryboard {}
