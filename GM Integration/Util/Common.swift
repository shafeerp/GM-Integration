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

class Common{
    //Constatnts
    public static let API_KEY  = "AIzaSyBycaYEo7FXCHljFyn4vEaIISiHXHwUPIU"
    public static let MY_LOCATION = CLLocation(latitude: 13.198540, longitude: 77.705910)
    
    //Scenarios
    
    public static let CURRENT_LOCATION = "current_location"
    public static let MUMBAI_AIRPORT = "mumbai_airport"
    public static let CHENNAI_AIRPORT = "chennai_aiportt"
    
    
    
    //Latitude and Longitudes
    public static let M_LOCATION = CLLocation(latitude: 19.089843,longitude: 72.865614)
    public static let C_LOCATION = CLLocation(latitude: 12.994149,longitude: 80.170880)
    
    public static func getCurrentLocation() -> CLLocation{
        let locationManager = CLLocationManager()
        var currentLocation = CLLocation()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled(){
            currentLocation = locationManager.location!
        }
        return currentLocation
    }
    
    public static func fetchCountryAndCity(location: CLLocation, completion: @escaping (String,String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            var address : String = ""
            var thoroughfare : String = ""
            if let error = error {
                print(error)
            }
            
            let place = placemarks! as [CLPlacemark]
            if place.count > 0 {
                let place = placemarks![0]
    
             
                if place.locality != nil {
                thoroughfare = thoroughfare + place.locality! + " - "
                }
                if place.postalCode != nil {
                thoroughfare = thoroughfare + place.postalCode! + "\n"
                }
                if place.subAdministrativeArea != nil {
                address = address + place.subAdministrativeArea! + " - "
                }
                if place.country != nil {
                address = address + place.country!
                }
            }
             completion(thoroughfare,address)
        }
    }
    
    public static func AddMarkerDetails() -> [MarkerDetails]{
        
        var markerDetails = [MarkerDetails]()
        let currentLocation = MarkerDetails(location: Common.MY_LOCATION, color: .green)
        let mumbaiAirport = MarkerDetails(location: Common.M_LOCATION, color: .red)
        let chennaiAirport = MarkerDetails(location: Common.C_LOCATION, color: .blue)
        markerDetails.append(currentLocation)
        markerDetails.append(mumbaiAirport)
        markerDetails.append(chennaiAirport)
        return markerDetails
    }
    
}

