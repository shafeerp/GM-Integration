//
//  MarkerDetails.swift
//  GM Integration
//
//  Created by Shafeer Puthalan on 10/06/18.
//  Copyright © 2018 Shafeer Puthalan. All rights reserved.
//


import CoreLocation
import UIKit
class MarkerDetails{
    
    var location : CLLocation?
    var color : UIColor?
    
    init(location:CLLocation,color:UIColor) {
        self.location = location
        self.color = color
    }
}
