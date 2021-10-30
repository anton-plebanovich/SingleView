//
//  NotificationViewController.swift
//  SingleViewExtension
//
//  Created by Anton Plebanovich on 30.10.21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import AppUtils
import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Utils.value1)
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }

}
