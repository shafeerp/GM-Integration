//
//  Constants.swift
//  GM Integration
//
//  Created by Shafeer Puthalan on 09/06/18.
//  Copyright © 2018 Shafeer Puthalan. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import GoogleMaps

class Common{
    //Constatnts
    
    public static let API_KEY  = "AIzaSyBycaYEo7FXCHljFyn4vEaIISiHXHwUPIU"
    
    //Latitude and Longitudes
    public static let M_LOCATION = CLLocation(latitude: 19.089560,longitude: 72.865614)
    public static let CHENNAI_LOCATION = CLLocation(latitude: 12.994112,longitude: 80.170867)
    
    public static func getCurrentLocation() -> CLLocation{
        let locationManager = CLLocationManager()
        var currentLocation = CLLocation()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled(){
            currentLocation = locationManager.location!
        }
        return currentLocation
    }
    
    public static func getAddress(location:CLLocation,completion: @escaping (String) -> Void){
        var myAddress = String()
        let coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
            if let addres = response?.firstResult(){
                let lines = addres.lines! as [String]
                myAddress = lines.joined()
                completion(myAddress)
                
            }
        }
        
    }
    
    public static func AddMarkerDetails() -> [MarkerDetails]{
        
        var markerDetails = [MarkerDetails]()
        let currentLocation = MarkerDetails(location: Common.getCurrentLocation(), color: .green)
        let mumbaiAirport = MarkerDetails(location: Common.M_LOCATION, color: .red)
        let chennaiAirport = MarkerDetails(location: Common.CHENNAI_LOCATION, color: .blue)
        markerDetails.append(currentLocation)
        markerDetails.append(mumbaiAirport)
        markerDetails.append(chennaiAirport)
        return markerDetails
    }
    
}

