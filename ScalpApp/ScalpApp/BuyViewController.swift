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
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        viewMap.delegate = self
        
        placeTicketParker()
        //viewMap.reloadInputViews()
//        super.viewDidLoad()
//        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
//        self.refresh()
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
        let query = PFQuery(className:"TicketInformationClass")
        query.includeKey("soldBy")
        query.findObjectsInBackgroundWithBlock { (tickets: [PFObject]?,error: NSError?) -> Void in
            if error == nil {
                if let tickets = tickets as? [PFObject]! {
                    for ticket in tickets {
                        
                        let user = ticket["soldBy"]
                        let userName = user["name"]!
                        let lat = ticket["latitude"]
                        let long = ticket["longitude"]
                        let event = ticket["event"]
                        let price = ticket["price"]
                        let status = ticket["status"] as! Bool
                        let objectid = ticket.objectId
                        let userNameAndObjectID = [userName!, objectid!]
                        print(userNameAndObjectID)
                        print(objectid)
                        
                        print("ticket has been sold: \(status)")
                        print(status)
                        print(userName!)
                        if status == false {
                        
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2DMake((lat as? Double)!, (long as? Double)!)
                        marker.title = event as? String
                        marker.snippet = price as? String
                        //marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
                        marker.icon = UIImage(named: "ticket50.png")
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
        let markerTitle = marker.title
        let markerSnippet = marker.snippet
        //var markerSeller = marker.userData
        print(markerTitle)
        print(markerSnippet)
        performSegueWithIdentifier("segueToBuyTickets", sender: marker)
}
    //takes information from the selected marker, and prepares the info to be passed to the next view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedMarker = sender
        if (segue.identifier == "segueToBuyTickets") {
        let yourNextViewController = segue.destinationViewController as! TicketInformationViewController
            yourNextViewController.eventInfo = (selectedMarker?.title)!
            yourNextViewController.eventPrice = (selectedMarker?.snippet)!
            yourNextViewController.sellerInfo = (selectedMarker?.userData)! as! NSArray //as! String
        }
    }
    //I changed the name of the button so it is a bit confusing, but this sends us to our 'user profile' vc
    @IBAction func userInfoMenuButtonPressed(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileFirst") 
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        reloadMapViewWhenTicketAdded()
    }
    
    func reloadMapViewWhenTicketAdded(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        viewMap.delegate = self
        placeTicketParker()
        viewMap.reloadInputViews()
      }
//    func refresh() {
//        self.reloadMapViewWhenTicketAdded()
//    }
}