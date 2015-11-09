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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        viewMap.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
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
        
        query.findObjectsInBackgroundWithBlock { (tickets: [PFObject]?,error: NSError?) -> Void in
            if error == nil {
                for object:PFObject in tickets! {
                    self.ticketInfoArray.append(object)
                        for markers in self.ticketInfoArray {
                        var marker = GMSMarker()
                        marker.position = CLLocationCoordinate2DMake((markers.objectForKey("latitude") as? Double)!, (markers.objectForKey("longitude") as? Double)!)
                        marker.title = markers.objectForKey("event") as? String
                        marker.snippet = markers.objectForKey("price") as? String
                        marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
                        marker.map = self.viewMap
                        var userForMarker = markers.objectForKey("user") as? String
                    }
                }
            }
        }
    }
    //creates LogOut funcitonality
    @IBAction func logOutButtonPressed(sender: AnyObject) {
        PFUser.logOut()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login") as! UIViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    //segues to the TicketInformationViewController when the marker window is tapped
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        var markerTitle = marker.title
        var markerSnippet = marker.snippet
        print(markerTitle)
        print(markerSnippet)
        performSegueWithIdentifier("segue2", sender: marker)
}
    //takes information from the selected marker, and prepares the info to be passed to the next view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedMarker = sender
        if (segue.identifier == "segue2") {
        var yourNextViewController = segue.destinationViewController as! TicketInformationViewController
            yourNextViewController.eventInfo = (selectedMarker?.title)!
            yourNextViewController.eventPrice = (selectedMarker?.snippet)!
            //yourNextViewController.sellerInfo = (selectedMarker?.)!
        }
    }
}
