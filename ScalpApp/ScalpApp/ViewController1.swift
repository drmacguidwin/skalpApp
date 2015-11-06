//
//  ViewController.swift
//  ScalpApp
//
//  Created by GC Student on 11/2/15.
//  Copyright © 2015 Dave MacGuidwin. All rights reserved.
//

import UIKit
import Parse


class ViewController1: UITabBarController {
    
    override func viewWillAppear(animated: Bool) {
        if (PFUser.currentUser() == nil) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login") as! UIViewController
                self.presentViewController(viewController, animated: true, completion: nil)
            })
        }
    }
}
