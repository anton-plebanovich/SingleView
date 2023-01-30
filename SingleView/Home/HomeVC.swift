//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import Lottie
import UIKit

final class HomeVC: UIViewController {
    
    // ******************************* MARK: - @IBOutlets
    
    @IBOutlet fileprivate var animationView1: LottieAnimationView!
    @IBOutlet fileprivate var animationView2: LottieAnimationView!
    @IBOutlet fileprivate var slider: UISlider!
    
    // ******************************* MARK: - Private Properties

    // ******************************* MARK: - Initialization and Setup
    
    // ******************************* MARK: - UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView1.loopMode = .loop
        animationView1.backgroundBehavior = .pauseAndRestore
        
        animationView2.loopMode = .loop
        animationView2.backgroundBehavior = .pauseAndRestore
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction fileprivate func onSlide(_ sender: UISlider) {
//        animationView.currentProgress = AnimationProgressTime(sender.value)
//        animationView.play()
    }
    
    @IBAction fileprivate func onPlay1Tap(_ sender: Any) {
        let time = CFAbsoluteTimeGetCurrent()
        let duration = animationView1.animation!.duration
        let progress = time.truncatingRemainder(dividingBy: duration) / duration
        animationView1.currentProgress = progress
        
        animationView1.play()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    @IBAction fileprivate func onPlay2Tap(_ sender: Any) {
        let time = CFAbsoluteTimeGetCurrent()
        let duration = animationView2.animation!.duration
        let progress = time.truncatingRemainder(dividingBy: duration) / duration
        animationView2.currentProgress = progress
        
        animationView2.play()
    }
}
