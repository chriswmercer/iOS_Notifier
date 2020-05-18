//
//  AlertService.swift
//  Reminder
//
//  Created by Chris Mercer on 18/05/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import UIKit

class AlertService {
    private init() {}
    
    static func actionSheet(in vc: UIViewController, actions: [Action], completion: @escaping (Int) -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      
        for action in actions {
            let action = UIAlertAction(title: action.title, style: .default) { (_) in
                completion(action.data)
            }
            alert.addAction(action)
        }
        vc.present(alert, animated: true)
    }
}

struct Action {
    var title: String
    var data: Int
}
