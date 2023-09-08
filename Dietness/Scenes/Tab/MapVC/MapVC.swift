//
//  MapVC.swift
//  Dietness
//
//  Created by mohamed dorgham on 02/03/2021.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit
import MapKit

extension MKMapView {
    func centerToLocation( _ location: CLLocation, regionRadius: CLLocationDistance = 1000 ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

class MapVC: UIViewController {
    var loc : CLLocation?
    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var cancelBtnOutlet: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var saveBtnOutlet: UIButton!
    @IBOutlet weak var myLocationBtn: MKUserTrackingBarButtonItem!
    var government: String?
    var city: String?
    var street: String?
    var userLat: Double?
    var userLong: Double?
    var currentLat: Double?
    var currentLong: Double?
    var delegate: RecieveLocation?
    var locationManager = CLLocationManager()
    var location : LocationCoordinate?
    var sourceLocationDetail : Bind<LocationDetail>? = Bind<LocationDetail>(nil)
    var currentLocation = Bind<LocationCoordinate>(defaultMapLocation)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Add Location".localized
        saveBtnOutlet.setTitle("SAVE".localized, for: .normal)
        let buttonItem = MKUserTrackingBarButtonItem(mapView: mapView)
        myLocationBtn = buttonItem
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
        
    }
    
    @objc private func geocoder(_ location: CLLocation) {
        // Create geocoder.
        let myGeocorder = CLGeocoder()
        myGeocorder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            guard placemarks?.count ?? 0 > 0 else {
                DispatchQueue.main.async {
                    self.descriptionLabel.text = "Unknown Location".localized
                }
                return }
            for placemark in placemarks! {
                print("Name: \(placemark.name ?? "Empty")")
                print("Country: \(placemark.country ?? "Empty")")
                print("ISOcountryCode: \(placemark.isoCountryCode ?? "Empty")")
                print("administrativeArea: \(placemark.administrativeArea ?? "Empty")")
                //                print("subAdministrativeArea: \(placemark.subAdministrativeArea ?? "Empty")")
                print("Locality: \(placemark.locality ?? "Empty")")
                //                print("PostalCode: \(placemark.postalCode ?? "Empty")")
                //                print("areaOfInterest: \(placemark.areasOfInterest ?? ["Empty"])")
                //                print("Ocean: \(placemark.ocean ?? "Empty")")
                //                print("Region: \(placemark.region?.identifier ?? "Empty")")
                print("Street: \(placemark.thoroughfare ?? "Empty")")
                print("user latitude = \(placemark.location?.coordinate.latitude ?? 0)")
                print("user longitude = \(placemark.location?.coordinate.longitude ?? 0)")
                self.government = placemark.administrativeArea ?? ""
                self.city = placemark.locality ?? ""
                self.street = placemark.thoroughfare ?? ""
                self.currentLat = placemark.location?.coordinate.latitude ?? 0
                self.currentLong = placemark.location?.coordinate.longitude ?? 0
                self.descriptionLabel.text = "\(placemark.country ?? "Empty") - \(placemark.administrativeArea ?? "Empty") - \(placemark.locality ?? "Empty") - \(placemark.name ?? "Empty")"
            }
        })
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func myLocationBtnAction(_ sender: Any) {
        print("My location")
        let center = CLLocationCoordinate2D(latitude: self.userLat ?? 0, longitude: self.userLong ?? 0)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.mapView.setRegion(region, animated: true)
    }
    @IBAction func saveBtnAction(_ sender: Any) {
        delegate?.passLocationBack(government: self.government ?? "", city: self.city ?? "", street: self.street ?? "", lat: "\(self.currentLat ?? 0)", lng: "\(self.currentLong ?? 0)")
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            
        }else {
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        locationManager.stopUpdatingLocation()
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        self.userLat = userLocation.coordinate.latitude
        self.userLong = userLocation.coordinate.longitude
    
        mapView.setRegion(region, animated: true)
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        UserDefaults.standard.set(userLocation.coordinate.latitude, forKey: "Lat")
        UserDefaults.standard.set(userLocation.coordinate.longitude, forKey: "Long")
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR!")
    }
}
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    }
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        let center = mapView.centerCoordinate
        loc = CLLocation(latitude: center.latitude, longitude: center.longitude)
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //         hide(false)
        let center = mapView.centerCoordinate
        print(center)
        loc = CLLocation(latitude: center.latitude, longitude: center.longitude)
        geocoder(loc!)
    }
}
protocol RecieveLocation {
    func passLocationBack(government: String,city: String,street: String,lat: String, lng: String)
}
