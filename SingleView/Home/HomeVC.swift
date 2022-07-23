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
    
    @IBOutlet fileprivate var imageView: UIImageView!
    
    // ******************************* MARK: - Private Properties

    // ******************************* MARK: - Initialization and Setup
    
    // ******************************* MARK: - UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        setImage(url: URL(string: "https://github.githubassets.com/images/modules/logos_page/Octocat.png")!)
        DispatchQueue.main.async {
            self.setImage(url: URL(string: "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png")!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func setImage(url: URL) {
        imageView.sd_setImage(with: url) { image, error, cacheType, url in
            
            if let error = error {
                print("Called error completion for '\(url!)': \(error)")
            } else {
                print("Called success completion for '\(url!)'")
            }
        }
    }
}
