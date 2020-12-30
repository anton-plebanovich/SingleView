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
    
    private let imageViews: [UIImageView] = {
        stride(from: 0, to: 1000, by: 1).map { index in
            let imageView = UIImageView()
            imageView.tag = index
            
            return imageView
        }
    }()
    
    var imageSet: [Int] = []
    
    // ******************************* MARK: - Private Properties
    
    private let url = URL(string: "https://raw.githubusercontent.com/SDWebImage/SDWebImage/master/SDWebImage_logo.png")!
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SDWebImageManager.shared.imageCache.clear(with: .all) {
            
        }
        
        imageViews.forEach { [self] imageView in
            imageSet.append(imageView.tag)
            imageView.sd_setImage(with: url) { _, _, _, _ in
                imageSet.removeAll { $0 == imageView.tag }
            }
        }
        
        DispatchQueue.main.async { [self] in
            imageViews[0..<100].forEach { imageView in
                imageView.sd_setImage(with: url) { _, _, _, _ in }
            }
            
            DispatchQueue.main.async { [self] in
                imageViews[100..<200].forEach { imageView in
                    imageView.sd_setImage(with: url) { _, _, _, _ in }
                }
                
                DispatchQueue.main.async { [self] in
                    imageViews[200..<300].forEach { imageView in
                        imageView.sd_setImage(with: url) { _, _, _, _ in }
                    }
                    
                    DispatchQueue.main.async { [self] in
                        imageViews[300..<400].forEach { imageView in
                            imageView.sd_setImage(with: url) { _, _, _, _ in }
                        }
                        
                        DispatchQueue.main.async { [self] in
                            imageViews[400..<500].forEach { imageView in
                                imageView.sd_setImage(with: url) { _, _, _, _ in }
                            }
                            
                            DispatchQueue.main.async { [self] in
                                imageViews[500..<600].forEach { imageView in
                                    imageView.sd_setImage(with: url) { _, _, _, _ in }
                                }
                                
                                DispatchQueue.main.async { [self] in
                                    imageViews[600..<700].forEach { imageView in
                                        imageView.sd_setImage(with: url) { _, _, _, _ in }
                                    }
                                    
                                    DispatchQueue.main.async { [self] in
                                        imageViews[700..<800].forEach { imageView in
                                            imageView.sd_setImage(with: url) { _, _, _, _ in }
                                        }
                                        
                                        DispatchQueue.main.async { [self] in
                                            imageViews[800..<900].forEach { imageView in
                                                imageView.sd_setImage(with: url) { _, _, _, _ in }
                                            }
                                            
                                            
                                            DispatchQueue.main.async { [self] in
                                                imageViews[900..<1000].forEach { imageView in
                                                    imageView.sd_setImage(with: url) { _, _, _, _ in }
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            if !imageSet.isEmpty {
                print("Completion wasn't called for: \(imageSet)")
            } else {
                print("Success!")
            }
        }
    }
}
