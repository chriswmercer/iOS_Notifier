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
        LocationService.instance.authorise()
        
        NotificationCenter.default.addObserver(self, selector: #selector(regionEntered), name: NSNotification.Name("region.entered"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAction), name: NSNotification.Name("handlAction"), object: nil)
        
    }
    
    @objc func handleAction(_ sender: Notification) {
        guard let action = sender.object as? AlertType else { return }
        switch action {
        case .Timer: print("Timer logic was fired")
        case .Date: print("Date logic was fired")
        case .Location: print ("Location logic was fired")
        }
    }
    
    @objc func regionEntered() {
        UserNotificationService.instance.locationRequest()
    }
    
    @IBAction func dateButtonPressed(_ sender: Any) {
        let actions: [Action] = [ Action(title: "Every minute at second 1", data: 1)]
        
        AlertService.actionSheet(in: self, actions: actions) {data in
            var components = DateComponents()
            components.second = data
            UserNotificationService.instance.dateRequest(with: components, text: "Every minute")
        }
    }
    
    @IBAction func timerButtonPressed(_ sender: Any) {
        let actions: [Action] = [ Action(title: "5 seconds", data: 5),
                                  Action(title: "30 seconds", data: 30),
                                  Action(title: "1 minute", data: 60)]
        
        AlertService.actionSheet(in: self, actions: actions) { data in
            UserNotificationService.instance.timerRequest(with: Double(data))
        }
    }
    
    @IBAction func loctionButtonPressed(_ sender: Any) {
        let actions: [Action] = [ Action(title: "When I return", data: 1)]
        
        AlertService.actionSheet(in: self, actions: actions) { data in
            LocationService.instance.updateLocation()
        }
    }
}

