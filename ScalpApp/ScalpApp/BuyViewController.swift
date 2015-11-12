//
//  BuyViewController.swift
//  ScalpApp
//
//  Created by GC Student on 11/3/15.
//  Copyright © 2015 Dave MacGuidwin. All rights reserved.
//

import UIKit
import GoogleMaps
import Parse


class BuyViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    

    @IBOutlet weak var viewMap: GMSMapView!

    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var ticketInfoArray = [PFObject]()
    var usersArray = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        viewMap.delegate = self
        
        placeTicketParker()
        viewMap.reloadInputViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        viewMap.delegate = self
        
        placeTicketParker()
        viewMap.reloadInputViews()
    }
    
    //This function gives permission to and starts the map display on your current location
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways {
            viewMap.myLocationEnabled = true
            locationManager.startUpdatingLocation()
            viewMap.settings.myLocationButton = true
        }
    }
    //This function tracks/updates and follows your current location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            viewMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
    //This function takes the information input from the seller, pulls it from Parse and creates a marker on buyer side map
    func placeTicketParker() {
        var query = PFQuery(className:"TicketInformationClass")
        query.includeKey("soldBy")
        query.findObjectsInBackgroundWithBlock { (tickets: [PFObject]?,error: NSError?) -> Void in
            if error == nil {
                if let tickets = tickets as? [PFObject]! {
                    for ticket in tickets {
                        
                        var user = ticket["soldBy"]
                        var userName = user["name"]!
                        var lat = ticket["latitude"]
                        var long = ticket["longitude"]
                        var event = ticket["event"]
                        var price = ticket["price"]
                        var status = ticket["status"] as! Bool
                        var objectid = ticket.objectId
                        var userNameAndObjectID = [userName!, objectid!]
                        print(userNameAndObjectID)
                        print(objectid)
                        
                        print("ticket has been sold: \(status)")
                        print(status)
                        print(userName!)
                        if status == false {
                        
                        var marker = GMSMarker()
                        marker.position = CLLocationCoordinate2DMake((lat as? Double)!, (long as? Double)!)
                        marker.title = event as? String
                        marker.snippet = price as? String
                        //marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
                        marker.icon = UIImage(named: "ticketx2")
                        marker.map = self.viewMap
                        marker.userData = userNameAndObjectID
                        //marker.opacity = 0.0
                        } else if status == true {
                            print("not showing the marker because the ticket is sold: \(status)")
                        }
                    }
                }
            }
        }
    }

    //segues to the TicketInformationViewController when the marker window is tapped
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        var markerTitle = marker.title
        var markerSnippet = marker.snippet
        var markerSeller = marker.userData
        print(markerTitle)
        print(markerSnippet)
        performSegueWithIdentifier("segueToBuyTickets", sender: marker)
}
    //takes information from the selected marker, and prepares the info to be passed to the next view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedMarker = sender
        if (segue.identifier == "segueToBuyTickets") {
        var yourNextViewController = segue.destinationViewController as! TicketInformationViewController
            yourNextViewController.eventInfo = (selectedMarker?.title)!
            yourNextViewController.eventPrice = (selectedMarker?.snippet)!
            yourNextViewController.sellerInfo = (selectedMarker?.userData)! as! NSArray //as! String
        }
    }
    //I changed the name of the button so it is a bit confusing, but this sends us to our 'user profile' vc
    @IBAction func userInfoMenuButtonPressed(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileFirst") as! UIViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
}