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
    
    func authorise() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        uncenter.requestAuthorization(options: options) { (granted, error) in
            if (error != nil) {
                print(error?.localizedDescription as String? ?? "An error occured")
                return
            }
            
            guard granted else {
                print("user denide access")
                return
            }
            
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
}
