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
    //This function takes the information input from the seller, and creates a marker on buyer side map
    func placeTicketParker() {
        for markers in allTickets.ticketList {
        var marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake((markers.latitude), (markers.longitude))
        marker.title = "Game: \(markers.event)"
        marker.snippet = "Price: \(markers.price)"
        marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        marker.map = viewMap
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
            yourNextViewController.stuff = (selectedMarker?.title)!
            
        }
    }
}
