//
//  LoginViewController.swift
//  Twitter
//
//  Created by Abid Amirali on 1/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.loginButton.layer.cornerRadius = self.loginButton.frame.height / 2
        self.loginButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let isLoggedIn = UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool else {return}
        if isLoggedIn {
            self.performSegue(withIdentifier: "toUserFeed", sender: self)
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let loginURL = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: loginURL, success: {
            // goto feed controller
            UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
            self.performSegue(withIdentifier: "toUserFeed", sender: self)
        }, failure: { (error) in
            AlertControllerHelper.presentAlert(for: self, withTitle: "Error!", withMessage: "Error with login\n" + error.localizedDescription)
        })
        
    }
    
    @IBAction func unwindToLogin(_ segue: UIStoryboardSegue) {}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
