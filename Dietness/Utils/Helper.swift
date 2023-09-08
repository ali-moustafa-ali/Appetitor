//
//  Helper.swift
//  Gaxa
//
//  Created by karim metawea on 5/14/20.
//  Copyright © 2020 Rami Suliman. All rights reserved.
//

import Foundation
import MOLH
import CoreLocation

typealias LocationCoordinate = CLLocationCoordinate2D
typealias LocationDetail = (address : String, coordinate :LocationCoordinate)
var defaultMapLocation = LocationCoordinate(latitude: 29.3327608, longitude: 47.9295125)
enum localizedValue{
    case message
    case name
}

class Helper {
    
    static func getLocalized(){
        
    }
    
    public static var language: String {
          
          get {
              
              return MOLHLanguage.currentAppleLanguage().contains("ar") ? "ar" : "en"
          }
      }
    
    public static func isEnglish() -> Bool {
        
        return MOLHLanguage.currentAppleLanguage() == "en"
    }
    
    public static func getAppLanguage() -> String {
           
           return MOLHLanguage.currentAppleLanguage()
       }

    
    public static func setAppLanguage(language: String) {
        
        let defaults = UserDefaults.standard
        switch language {
        case "ar":
            defaults.set(["ar", "en"], forKey: "AppleLanguages")
            break
        default:
            defaults.set(["en", "ar"], forKey: "AppleLanguages")
            break
        }
        defaults.synchronize()
    }
    
    public static func getAddress(location: CLLocationCoordinate2D, action: ((_ address: String) -> Void)!) {
        
        let loc = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(loc, preferredLocale: Locale(identifier: Helper.getAppLanguage())) { (markers, error) in
            
            if let _ = error {
                
                action("Unkown address")
            } else {
                
                if let place = markers?.first {
                    
                    var address = ""
                    if let thoro = place.locality {
                        address = address + thoro
                    }
                    if let thoro = place.administrativeArea {
                     address = address + ", " + thoro
                     }
                    if let thoro = place.country {
                        address = address + " , " + thoro
                    }
                    
                    action(address)
                } else {
                    
                    action("Unkown address")
                }
            }
        }
    }
    
    public static func getAddress(location: CLLocationCoordinate2D,language:String, prefix: String, action: ((_ address: String,_ city:String) -> Void)!) {
        
        let loc = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(loc, preferredLocale: Locale(identifier:language)) { (markers, error) in
            
            if let _ = error {
                
                action("Unkown address","")
            } else {
                
                if let place = markers?.first {
                    
                    let address = [
                    place.subThoroughfare,
                    place.thoroughfare,
                    place.subLocality,
                    place.locality,place.administrativeArea
                    ].compactMap{$0}.joined(separator: ", ")
//
//                    if !prefix.isEmpty {
//                        address = prefix
//                    }
//
//
//                    if let zone = place.administrativeArea{
//                        if !address.isEmpty {
//                        address = address + " , "
//                        }
//                        address = address + zone
//                    }
//
//
//                    if let subStreet = place.subThoroughfare{
//                        if !address.isEmpty {
//                        address = address + " , "
//                        }
//                        address = address + subStreet
//                    }
//
//
//                    if let street = place.thoroughfare{
//                        if !address.isEmpty {
//                            address = address + " , "
//                            }
//                            address = address + street
//                    }
//
//                    if let area = place.subLocality{
//                        if !address.isEmpty {
//                            address = address + " , "
//                        }
//                        address = address + area
//                    }
                    
                    
//                    if let thoro = place.locality {
//                        
//                        if !address.isEmpty {
//                            address = address + " , "
//                        }
//                        address = address + thoro
//                    }
//                    
//                    if let thoro = place.administrativeArea {
//
//                     if !address.isEmpty {
//                     address = address + " - "
//                     }
//                     address = address + thoro
//                     }
//                    if let thoro = place.country {
//
//                        if !address.isEmpty {
//                            address = address + " , "
//                        }
//                        address = address + thoro
//                    }
                    
                    action(address,place.locality ?? "")
                } else {
                    
                    action("Unkown address","")
                }
            }
        }
    }
    
    
    
    
    static func displayAlert(message: String, buttonTitle: String, vc: UIViewController)
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)

        let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        let titleAttrString = NSMutableAttributedString(string: "", attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)

        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        let okAction = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertController.addAction(okAction)

        vc.present(alertController, animated: true, completion: nil)
    }
    public static func  convertImageToBase64String(image : UIImage ) -> String
    {
        let strBase64 =  image.jpegData(compressionQuality: 0.5)?.base64EncodedString()
        return strBase64!
    }

    
}
