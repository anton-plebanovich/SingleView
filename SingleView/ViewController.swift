//
//  ViewController.swift
//  SingleView
//
//  Created by Anton Plebanovich on 6/20/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.attributedText = getAttributedName("Label should be stroked", buyProgress: 1)
        label.text = nil
        label.attributedText = getAttributedName("Label shouldn't be stroked", buyProgress: 0)
    }
    
    private func getAttributedName(_ name: String, buyProgress: Double) -> NSAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: name)
        
        let fullRange = NSRange(location: 0, length: attributeString.length)
        attributeString.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: fullRange)
        
        let buyLength = Int(Double(attributeString.length) * buyProgress)
        let buyRange = NSRange(location: 0, length: buyLength)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: buyRange)
        
        return attributeString
    }
}

