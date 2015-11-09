//
//  SellViewController.swift
//  ScalpApp
//
//  Created by GC Student on 11/3/15.
//  Copyright © 2015 Dave MacGuidwin. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

class SellViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var eventLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    
    var locationManager: CLLocationManager?
    //var locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sellTicketButtonPressed(sender: AnyObject) {
        
        if locationManager == nil {
            locationManager = CLLocationManager()
        }
        
        locationManager?.requestAlwaysAuthorization()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 50.0
        
        // Conditional check of locationServicesEnabled method
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
            print("location services enabled")
        }
}
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
                
        let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
        
            let ticketInformation = PFObject(className: "TicketInformationClass")
            ticketInformation["event"] = eventLabel.text!
            ticketInformation["price"] = priceLabel.text!
            ticketInformation["latitude"] = (locValue.latitude)
            ticketInformation["longitude"] = (locValue.longitude)
            ticketInformation["user"] = PFUser.currentUser()
            ticketInformation.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    print("saved")
                } else {
                    print("error")
                }
            }
        
        locationManager?.stopUpdatingLocation()

        eventLabel.text = nil
        priceLabel.text = nil
        
        let alert = UIAlertController(title: "Your Tix Are Online", message: "Wait for Buyers!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
        
    }
}