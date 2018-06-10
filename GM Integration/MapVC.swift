//
//  MapVC.swift
//  GM Integration
//
//  Created by Shafeer Puthalan on 09/06/18.
//  Copyright © 2018 Shafeer Puthalan. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapVC: UIViewController{
    
    @IBOutlet var mapView: GMSMapView!
    
    var markerDetails = [MarkerDetails]()
    
    var clickedMarker = GMSMarker()
    
    private var infoWindow = MapMarkerWindow()
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       locationManager.requestWhenInUseAuthorization()
        showMap()
        self.infoWindow = loadNiB()
    }
   
    func showMap(){
        
        markerDetails = Common.AddMarkerDetails()
        mapView.camera = GMSCameraPosition(target: Common.MY_LOCATION.coordinate, zoom: 6, bearing: 0, viewingAngle: 0)
      
            for marker in markerDetails{
                let location = CLLocationCoordinate2D(latitude: (marker.location?.coordinate.latitude)!, longitude: (marker.location?.coordinate.longitude)!)
                let markers = GMSMarker(position: location)
                markers.icon = GMSMarker.markerImage(with: marker.color)
                markers.map = mapView
            }
        }
    
    
     func showRoute(){
        infoWindow.removeFromSuperview()
        mapView.clear()
        showMap()
        let currentLocation = Common.getCurrentLocation()
        
        let origin = "\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)"
        let destination = "\(clickedMarker.layer.latitude),\(clickedMarker.layer.longitude)"
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(Common.API_KEY)"
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let routes = json["routes"] as! NSArray
                    print("json ois \(json)")
                    //self.mapView.clear()
                    
                    OperationQueue.main.addOperation({
                        for route in routes
                        {
                            let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                            let points = routeOverviewPolyline.object(forKey: "points")
                            let path = GMSPath.init(fromEncodedPath: points! as! String)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 3
                            
                            let bounds = GMSCoordinateBounds(path: path!)
                            self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                            
                            polyline.map = self.mapView
                            
                        }
                    })
                }catch let error as NSError{
                    print("error:\(error)")
                }
            }
        }).resume()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
   
    
    
    func loadNiB() -> MapMarkerWindow{
        let infoWindow = MapMarkerWindow.instanceFromNib() as! MapMarkerWindow
        return infoWindow
    }
    
}

extension MapVC : GMSMapViewDelegate,MapMarkerDelegate{
    
    func didTapDirectionButton() {
        showRoute()
    }
    
    
   
   func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let loc = CLLocation(latitude: marker.layer.latitude, longitude: marker.layer.longitude)
        Common.fetchCountryAndCity(location: loc) { (addr1, addr2) in
            self.clickedMarker = marker
            self.infoWindow.removeFromSuperview()
            self.self.infoWindow = self.loadNiB()
            let location = marker.position
            self.infoWindow.delegate = self
            self.infoWindow.alpha = 0.9
            self.infoWindow.layer.borderColor = marker.layer.borderColor
            self.infoWindow.layer.cornerRadius = 12
            self.infoWindow.layer.borderWidth = 4
            self.infoWindow.directionButton.layer.cornerRadius = self.infoWindow.directionButton.frame.height / 2
            self.infoWindow.addressLabel.text = addr1 + addr2
            self.infoWindow.center = mapView.projection.point(for: location)
            self.infoWindow.center.y = self.infoWindow.center.y - 82
            self.view.addSubview(self.infoWindow)
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
       
            let location = clickedMarker.position
            infoWindow.center = mapView.projection.point(for: location)
            infoWindow.center.y = infoWindow.center.y - 82
        
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return nil
    }

}


