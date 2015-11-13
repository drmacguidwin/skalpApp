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

class SellViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var eventLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventLabel.delegate = self
        priceLabel.delegate = self
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
        let eventDate = location?.timestamp
        let howRecent = eventDate?.timeIntervalSinceNow
        
        print(location)
        print(eventDate)
        print(howRecent)
                
        let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
        
            let ticketInformation = PFObject(className: "TicketInformationClass")
            ticketInformation["event"] = eventLabel.text!
            ticketInformation["price"] = priceLabel.text!
            ticketInformation["latitude"] = (locValue.latitude)
            ticketInformation["longitude"] = (locValue.longitude)
            ticketInformation["soldBy"] = PFUser.currentUser()
            ticketInformation["status"] = false
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
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    
    }
    
    @IBAction func userInfoPuttonPressed(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileFirst") as! UIViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}