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
    
    var stuff = ""
   

    @IBOutlet weak var displayGameInfo: UILabel!
    @IBOutlet weak var displayGamePrice: UILabel!
    @IBOutlet weak var displaySellerName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayGameInfo.text = stuff
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}