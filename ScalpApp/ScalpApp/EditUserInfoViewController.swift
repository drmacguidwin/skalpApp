//
//  EditUserInfoViewController.swift
//  ScalpApp
//
//  Created by GC Student on 11/10/15.
//  Copyright © 2015 Dave MacGuidwin. All rights reserved.
//

import UIKit
import Parse


class EditUserInfoViewController: UIViewController {

    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    var editProfileData = [PFObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func saveUserInfoButtonPressed(sender: AnyObject) {
        
        if let editUserQuery = PFUser.query() {
            editUserQuery.findObjectsInBackgroundWithBlock { (profilesToEdit: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    
                    for object:PFObject in profilesToEdit! {
                        self.editProfileData.append(object)
                        
                        if object.objectId == PFUser.currentUser()?.objectId {
                            object["name"] = self.nameField.text!
                            object["phoneNumber"] = self.phoneNumberField.text!
                            
                            object.saveInBackground()
                        }
                    }
                    var alert = UIAlertView(title: "Success", message: "Information Saved", delegate: self, cancelButtonTitle: "Ok")
                    alert.show()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home") as! UIViewController
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                } else {
                    print(error)
                }
            }
        }
    }
}