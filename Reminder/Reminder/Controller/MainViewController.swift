//
//  ViewController.swift
//  Reminder
//
//  Created by Chris Mercer on 17/05/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserNotificationService.instance.authorise()
    }

    @IBAction func dateButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func timerButtonPressed(_ sender: Any) {
        UserNotificationService.instance.timerRequest(with: 5)
    }
    
    @IBAction func loctionButtonPressed(_ sender: Any) {
        
    }
}

