//
//  AlertControllerHelper.swift
//  Twitter
//
//  Created by Abid Amirali on 1/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

struct AlertControllerHelper {
    
    static func presentAlert(for viewController: UIViewController, withTitle title: String, withMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}
