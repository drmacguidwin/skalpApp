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
    var sellerInfo = []
   

    @IBOutlet weak var displayGameInfo: UILabel!
    @IBOutlet weak var displayGamePrice: UILabel!
    @IBOutlet weak var displaySellerName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayGameInfo.text = eventInfo
        displayGamePrice.text = eventPrice
        displaySellerName.text = sellerInfo[0] as! String
        print(sellerInfo[1])
        
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
    
    func findAndDeleteRowInParse() {
        var query = PFQuery(className:"TicketInformationClass")
        query.findObjectsInBackgroundWithBlock { (tickets: [PFObject]?,error: NSError?) -> Void in
            if error == nil {
                let objectIdString:String = self.sellerInfo[1] as! String
                if let tickets = tickets as? [PFObject]! {
                    for ticket in tickets {
                        if ticket.objectId == objectIdString {
                            ticket["status"] = true
                            ticket.deleteInBackground()
                            ticket.saveInBackground()
                        } else {
                            print("this didn't delete")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func buyTicketsButtonPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "If You Have Exchanged Tickets With the Seller", message: "Press 'Buy' To Complete Transaction!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "BUY", style: UIAlertActionStyle.Default, handler: { action in
            print("you clicked buy")
            self.findAndDeleteRowInParse()
            
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