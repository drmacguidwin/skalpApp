//
//  TicketInformationViewController.swift
//  ScalpApp
//
//  Created by GC Student on 11/6/15.
//  Copyright © 2015 Dave MacGuidwin. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps


class TicketInformationViewController: UIViewController, GMSMapViewDelegate {
    
    var eventInfo = ""
    var eventPrice = ""
    var sellerInfo = ""
   

    @IBOutlet weak var displayGameInfo: UILabel!
    @IBOutlet weak var displayGamePrice: UILabel!
    @IBOutlet weak var displaySellerName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayGameInfo.text = eventInfo
        displayGamePrice.text = eventPrice
        displaySellerName.text = sellerInfo
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func userInfoButtonPressed(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileFirst") as! UIViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    
    
    
    @IBAction func buyTicketsButtonPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "If You Have Exchanged Tickets With the Seller", message: "Press 'Buy' To Complete Transaction!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "BUY", style: UIAlertActionStyle.Default, handler: { action in
            print("you clicked buy")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home") as! UIViewController
                self.presentViewController(viewController, animated: true, completion: nil)
            })
        }))
        alert.addAction(UIAlertAction(title:"Cancel", style: UIAlertActionStyle.Cancel, handler: { action in
            print("you clicked cancel")
        }))
        presentViewController(alert, animated: true, completion: nil)

    }
}