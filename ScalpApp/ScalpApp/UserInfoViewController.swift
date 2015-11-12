//
//  UserInfoViewController.swift
//  ScalpApp
//
//  Created by GC Student on 11/10/15.
//  Copyright © 2015 Dave MacGuidwin. All rights reserved.
//

import UIKit
import Parse


class UserInfoViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var userInformation = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentProfileInformation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func presentProfileInformation() {
        
        var query = PFUser.query()
        //query?.whereKey("objectID", equalTo: (PFUser.currentUser()?.objectId!)!)
        query?.whereKey("username", equalTo: (PFUser.currentUser()?.username!)!)
        //ABOVE LINE WAS THE KEY CHANGE....
        query!.findObjectsInBackgroundWithBlock { (profiles: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                //self.userInformation.removeAll()
                for object:PFObject in profiles! {
                    self.userInformation.append(object)
                    print(self.userInformation.count)
                    for data in self.userInformation {
                        self.userNameLabel.text = data.objectForKey("name") as? String
                        self.phoneNumberLabel.text = data.objectForKey("phoneNumber") as? String
                        self.emailLabel.text = data.objectForKey("email") as? String
                    }
                }
            } else {
                print(error)
            }
        }
    }
    
    @IBAction func logOutButtonPressed(sender: AnyObject) {
        PFUser.logOut()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginFirst") as! UIViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    
    @IBAction func returnToSkalpApp(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home") as! UIViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    
    @IBAction func editProfileButtonPressed(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EditVC") as! UIViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
}