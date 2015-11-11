//
//  UserTicketListViewController.swift
//  ScalpApp
//
//  Created by GC Student on 11/10/15.
//  Copyright © 2015 Dave MacGuidwin. All rights reserved.
//

import UIKit
import Parse


class UserTicketListViewController: UITableViewController {

    @IBOutlet var yourTicketsTableView: UITableView!
    var usersTickets = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callTicketInfoFromCurrentUser()
        print(usersTickets.count)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        yourTicketsTableView.reloadData()
    }
    
    func callTicketInfoFromCurrentUser() {
        let query = PFQuery(className: "TicketInformationClass")
        if let user = PFUser.currentUser() {
            query.whereKey("soldBy", equalTo: user)
            query.findObjectsInBackgroundWithBlock { (tickets: [PFObject]?,error: NSError?) -> Void in
                if error == nil {
                    for object:PFObject in tickets! {
                        self.usersTickets.append(object)
                        print("*********")
                        print(self.usersTickets.count)
                        for ticketsForSale in self.usersTickets {
                            var ticketPrice = ticketsForSale.objectForKey("price") as? String
                            var eventName = ticketsForSale.objectForKey((("event") as? String)!)
                            print(ticketPrice!)
                            print(eventName!)
                            
                            self.yourTicketsTableView.reloadData()
                            
                            //print(self.usersTickets)
                        }
                    }
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersTickets.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        
        let ticket:PFObject = self.usersTickets[indexPath.row]
        
        
        cell!.textLabel?.text = ticket.objectForKey("event") as? String
        cell!.detailTextLabel?.text = ticket.objectForKey("price") as? String
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let ticket:PFObject = self.usersTickets[indexPath.row]
            ticket.deleteInBackground()
            self.usersTickets.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            ticket.saveInBackground()
        }
}
}