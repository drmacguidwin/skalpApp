//
//  SignUpViewController.swift
//  ScalpApp
//
//  Created by GC Student on 11/5/15.
//  Copyright © 2015 Dave MacGuidwin. All rights reserved.
//

import UIKit
import Parse


class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        let username = self.usernameField.text
        let password = self.passwordField.text
        let email = self.emailField.text
        let finalEmail = email?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
        
        let newUser = PFUser()
        
        newUser.username = username
        newUser.password = password
        newUser.email = finalEmail
        newUser["name"] = ""
        newUser["phoneNumber"] = ""
        
        newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
            spinner.stopAnimating()
            if ((error) != nil) {
                let alert = UIAlertView(title: "error", message: "\(error)", delegate: self, cancelButtonTitle: "Ok")
                alert.show()
            } else {
                let alert = UIAlertView(title: "Your Account Has Been Created", message: "For Best Service, Please Provide Us With Your Name and Phone Number", delegate: self, cancelButtonTitle: "Ok")
                alert.show()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EditVC") 
                    self.presentViewController(viewController, animated: true, completion: nil)
                })
             }
        })
    }
}