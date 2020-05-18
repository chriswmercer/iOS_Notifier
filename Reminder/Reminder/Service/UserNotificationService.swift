//
//  UserNotificationService.swift
//  Reminder
//
//  Created by Chris Mercer on 17/05/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import Foundation
import UserNotifications

class UserNotificationService: NSObject, UNUserNotificationCenterDelegate {
    
    private override init() {}
    static let instance = UserNotificationService()
    
    let uncenter = UNUserNotificationCenter.current()
    var approved = false
    
    func authorise() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        uncenter.requestAuthorization(options: options) { (granted, error) in
            if (error != nil) {
                print(error?.localizedDescription as String? ?? "An error occured")
                return
            }
            
            guard granted else {
                print("user denied access")
                self.approved = false
                return
            }

            self.approved = true
            self.configure()
        }
    }
    
    func configure() {
        uncenter.delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
    
    func timerRequest(with interval: TimeInterval) {
        if (approved) {
            let content = UNMutableNotificationContent()
            content.title = "Timer Finished"
            content.body = "Your timer has finished"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
            let request = UNNotificationRequest(identifier: "userNotification.timer", content: content, trigger: trigger)
            uncenter.add(request) { (error) in
                if(error != nil) {
                    print("Error \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    
    func dateRequest(with components: DateComponents) {
        
    }
    
    func locationRequest() {
        
    }
}
