//
//  GoogleMapsHelper.swift
//  User
//
//  Created by MacBookPro on 09/05/18.
//  Copyright © 2018 Ragab Mohammed. All rights reserved.
//

import Foundation
//import GoogleMaps
import MapKit


//extension GMSAddress {
//    var formattedAddress: String {
//        let addressComponents = [
//            thoroughfare,        // One Infinite Loop
//            locality,            // Cupertino
//            administrativeArea,  // California
//            postalCode           // 95014
//        ]
//        return addressComponents
//            .compactMap { $0 }
//            .joined(separator: ", ")
//    }
//
//}

typealias LocationCoordinate = CLLocationCoordinate2D
typealias LocationDetail = (address : String, coordinate :LocationCoordinate)

var drawpolylineCheck : (()->())?

private struct Place : Decodable {
    
    var results : [Address]?
    
}

private struct Address : Decodable {
    
    var formatted_address : String?
    var geometry : Geometry?
}

private struct Geometry : Decodable {
    
    var location : GLocation?
    
}

private struct GLocation : Decodable {
    
    var lat : Double?
    var lng : Double?
}



//class GoogleMapsHelper : NSObject {
//
//    var mapView : GMSMapView?
//    var locationManager : CLLocationManager?
//    private var currentLocation : ((CLLocation)->Void)?
//
//    func getMapView(withDelegate delegate: GMSMapViewDelegate? = nil, in view : UIView, withPosition position :LocationCoordinate = defaultMapLocation, zoom : Float = 18) {
//
//       mapView = GMSMapView(frame: view.frame)
//       self.setMapStyle(to : mapView)
//       mapView?.isMyLocationEnabled = true
//       mapView?.delegate = delegate
//       mapView?.camera = GMSCameraPosition.camera(withTarget: position, zoom: 18)
//       view.addSubview(mapView!)
//    }
//
//    func getCurrentLocation(onReceivingLocation : @escaping ((CLLocation)->Void)){
//
//        locationManager = CLLocationManager()
//        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager?.requestWhenInUseAuthorization()
//        locationManager?.distanceFilter = 50
//        locationManager?.startUpdatingLocation()
//        locationManager?.delegate = self
//        self.currentLocation = onReceivingLocation
//    }
//
//    func moveTo(location : LocationCoordinate = defaultMapLocation, with center : CGPoint) {
//
//        CATransaction.begin()
//        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
//        CATransaction.setCompletionBlock {
//            self.mapView?.animate(to: GMSCameraPosition.camera(withTarget: location, zoom: 18))
//        }
//        CATransaction.commit()
////        self.mapView?.center = center  //  Getting current location marker to center point
//
//    }
//    // Setting Map Style
//    private func setMapStyle(to mapView: GMSMapView?){
//        do {
//            // Set the map style by passing a valid JSON string.
//            if let url = Bundle.main.url(forResource: "Map_style", withExtension: "json") {
//                mapView?.mapStyle = try GMSMapStyle(contentsOfFileURL: url)
//            }else {
//                print("error")
//            }
//
//        } catch {
//            NSLog("One or more of the map styles failed to load. \(error)")
//        }
//    }
//    func getPlaceAddress(from location : LocationCoordinate, on completion : @escaping ((LocationDetail)->())){
////
//
//        var address : String = ""
//        let geocoder = GMSGeocoder()
//        geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2DMake(location.latitude, location.longitude), completionHandler: {response,error in
//            if let gmsAddress = response!.firstResult(){
//                for line in  gmsAddress.lines! {
//                    address += line + " "
//                }
//                completion((address, location))
//            }
//        })
//    }
//
//
//}


//extension GoogleMapsHelper: CLLocationManagerDelegate {
//
//    // Handle incoming location events.
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//          print("Location: \(location)")
//          self.currentLocation?(location)
//        }
//
//    }
//
//    // Handle authorization for the location manager.
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .restricted:
//            print("Location access was restricted.")
//        case .denied:
//            print("User denied access to location.")
//        case .notDetermined:
//            print("Location status not determined.")
//        case .authorizedAlways: fallthrough
//        case .authorizedWhenInUse:
//            print("Location status is OK.")
//        @unknown default:
//            print("Location status not determined.")
//        }
//    }
//
//    // Handle location manager errors.
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        locationManager?.stopUpdatingLocation()
//        print("Error: \(error)")
//    }
//    func checkPolyline(coordinate: CLLocationCoordinate2D)  {
//    }
//}
