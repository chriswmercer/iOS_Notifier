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
        setupActionsAndCategories()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let action = AlertType(rawValue: response.actionIdentifier) {
            NotificationCenter.default.post(name: NSNotification.Name("handlAction"), object: action)
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
    
    func getAttachment(for type: AlertType) -> UNNotificationAttachment? {
        var imageName: String
        switch type {
        case .Timer: imageName = "TimeAlert"
        case .Date: imageName = "DateAlert"
        case .Location: imageName = "LocationAlert"
        }
        
        guard let url = Bundle.main.url(forResource: imageName, withExtension: "png") else { return nil }
        do {
            let attachment = try UNNotificationAttachment(identifier: type.rawValue, url: url)
            return attachment
        } catch {
            return nil
        }
    }
    
    func setupActionsAndCategories() {
        let timerAction = UNNotificationAction(identifier: AlertType.Timer.rawValue, title: "Run timer logic", options: [.authenticationRequired])
        let dateAction = UNNotificationAction(identifier: AlertType.Date.rawValue, title: "Run date logic", options: [.destructive])
        let locAction = UNNotificationAction(identifier: AlertType.Location.rawValue, title: "Run location logic", options: [.foreground])
        
        let timerCategoy = UNNotificationCategory(identifier: AlertType.Timer.rawValue, actions: [timerAction], intentIdentifiers: [], options: [])
        let dateCategoy = UNNotificationCategory(identifier: AlertType.Date.rawValue, actions: [dateAction], intentIdentifiers: [], options: [])
        let locCategory = UNNotificationCategory(identifier: AlertType.Location.rawValue, actions: [locAction], intentIdentifiers: [], options: [])
        
        uncenter.setNotificationCategories([timerCategoy, dateCategoy, locCategory])
    }
    
    func timerRequest(with interval: TimeInterval) {
        if (approved) {
            let content = UNMutableNotificationContent()
            content.title = "Timer Finished"
            content.body = "Your timer for \(Int(interval)) seconds has finished"
            content.sound = .default
            content.badge = 1
            if let attachment = getAttachment(for: .Timer) { content.attachments.append(attachment) }
            content.categoryIdentifier = AlertType.Timer.rawValue
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
            let request = UNNotificationRequest(identifier: "userNotification.timer", content: content, trigger: trigger)
            uncenter.add(request) { (error) in
                if(error != nil) {
                    print("Error \(String(describing: error?.localizedDescription))")
                }
            }
        } else {
            authorise()
        }
    }
    
    func dateRequest(with components: DateComponents, text: String = "No Message") {
        if (approved) {
            let content = UNMutableNotificationContent()
            content.title = "Date Notification"
            content.body = "Your date notification has been triggered with message: \(text)"
            content.sound = .default
            content.badge = 1
            if let attachment = getAttachment(for: .Date) { content.attachments.append(attachment) }
            content.categoryIdentifier = AlertType.Date.rawValue
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: "userNotification.date", content: content, trigger: trigger)
            uncenter.add(request) { (error) in
                if(error != nil) {
                    print("Error \(String(describing: error?.localizedDescription))")
                }
            }
        } else {
            authorise()
        }
    }
    
    func locationRequest() {
        if (approved) {
            let content = UNMutableNotificationContent()
            content.title = "Location Notification"
            content.body = "You have returned"
            content.sound = .default
            content.badge = 1
            if let attachment = getAttachment(for: .Location) { content.attachments.append(attachment) }
            content.categoryIdentifier = AlertType.Location.rawValue

            let request = UNNotificationRequest(identifier: "userNotification.loc", content: content, trigger: nil)
            uncenter.add(request) { (error) in
                if(error != nil) {
                    print("Error \(String(describing: error?.localizedDescription))")
                }
            }
        } else {
            authorise()
        }
    }
}

enum AlertType: String {
    case Timer = "timer"
    case Date = "date"
    case Location = "location"
}
