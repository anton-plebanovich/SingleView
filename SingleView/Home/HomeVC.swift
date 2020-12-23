//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import UIKit
import SDWebImage

final class HomeVC: UIViewController {
    
    // ******************************* MARK: - @IBOutlets
    
    @IBOutlet private var imageView: UIImageView!
    
    // ******************************* MARK: - Private Properties
    
    private let url = URL(string: "https://raw.githubusercontent.com/SDWebImage/SDWebImage/master/SDWebImage_logo.png")!
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Works well on the FIRST app launch only.
        // Clearing cache doesn't help.
        SDImageCache.shared.clear(with: .all) { [self] in
            
            print("set image")
            imageView.sd_setImage(with: url) { _, _, _, _ in
                print("completion")
            }
            
            DispatchQueue.main.async { [self] in
                print("cancel")
                imageView.sd_cancelCurrentImageLoad()
            }
        }
    }
}
