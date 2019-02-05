//
//  ComposeTweetViewController.swift
//  Tweeta
//
//  Created by Abid Amirali on 2/4/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {
    
    @IBOutlet weak var postTweetButton: UIButton!
    
    @IBOutlet weak var characterCountLabel: UILabel!
//    @IBOutlet weak var tweetTextField: UITextField!
    @IBOutlet weak var tweetTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.postTweetButton.layer.borderColor = UIColor.white.cgColor
        self.postTweetButton.layer.borderWidth = 2
        self.postTweetButton.layer.cornerRadius = self.postTweetButton.bounds.height / 2
        
        self.tweetTextView.becomeFirstResponder()
        
    }
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        
        
    }

    
    @IBAction func postTweetButtonPressed(_ sender: UIButton) {
        if tweetTextView.text.count <= 0  {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        TwitterAPICaller.client?.postTweet(withText: tweetTextView.text, completion: { (success, errorString) in
            if !success {
                AlertControllerHelper.presentAlert(for: self, withTitle:
                    "Error", withMessage: errorString!)
            }
            self.dismiss(animated: true, completion: nil)
        })
        
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension ComposeTweetViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count <= 0  {
            self.characterCountLabel.text = "0"
            return
        }
        //
        self.characterCountLabel.text = "\(textView.text.count)"
    }
}
