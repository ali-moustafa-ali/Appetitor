//
//  Colors.swift
//  User
//
//  Created by MacBookPro on 12/22/17.
//  Copyright © 2017 Ragab Mohammed. All rights reserved.
//

import UIKit

enum Color : Int {
    
    case primary = 1
    case secondary = 2
    case lightBlue = 3
    case brightBlue = 4
    
    
    static func valueFor(id : Int)->UIColor?{
        
        switch id {
        case self.primary.rawValue:
            return .primary
            
        case self.secondary.rawValue:
            return .secondary
            
        case self.lightBlue.rawValue:
            return .lightBlue
            
        case self.brightBlue.rawValue:
            return .brightBlue
            
        default:
            return nil
        }
        
        
    }
    
    
}

extension UIColor {
    
    static var systemBackground: UIColor {
        let lightColor = UIColor.white
        let darkColor = UIColor.black
        if #available(iOS 13.0, *) {
            return UIColor { $0.userInterfaceStyle == .light ? lightColor : darkColor }
        }
        return lightColor
    }
    
    // Primary Color
    static var primary : UIColor {
//        return  UIColor(red: 246/255, green: 147/255, blue: 28/255, alpha: 1)
        return  UIColor(red: 215/255, green: 36/255, blue: 74/255, alpha: 1)

    }
    static var secondary : UIColor {
    //        return  UIColor(red: 246/255, green: 147/255, blue: 28/255, alpha: 1)
//            return  UIColor(red: 28/255, green: 168/255, blue: 237/255, alpha: 1)
        return  UIColor(red: 215/255, green: 36/255, blue: 74/255, alpha: 1)

        }
    // Secondary Color
//    static var secondary : UIColor {
////        return  UIColor(red: 246/255, green: 147/255, blue: 28/255, alpha: 1)
//        return  UIColor(red: 215/255, green: 36/255, blue: 74/255, alpha: 1)
//
//    }
    
    // Secondary Color
    static var rating : UIColor {
        return #colorLiteral(red: 0.9921568627, green: 0.7882352941, blue: 0.1568627451, alpha: 1) //UIColor(red: 238/255, green: 98/255, blue: 145/255, alpha: 1)
    }
    
    // Secondary Color
    static var lightBlue : UIColor {
        return #colorLiteral(red: 0.1490196078, green: 0.462745098, blue: 0.737254902, alpha: 1) //UIColor(red: 38/255, green: 118/255, blue: 188/255, alpha: 1)
    }
    
    //Gradient Start Color
    static var startGradient : UIColor {
        return UIColor(red: 83/255, green: 173/255, blue: 46/255, alpha: 1)
    }
    
    //Gradient End Color
    static var endGradient : UIColor {
        return UIColor(red: 158/255, green: 178/255, blue: 45/255, alpha: 1)
    }
    
    // Blue Color
    static var brightBlue : UIColor {
        return UIColor(red: 40/255, green: 25/255, blue: 255/255, alpha: 1)
    }
    static var backgroundColor : UIColor {
      return UIColor.init(hex: 0xF9F9F9)
    }
    func UInt()->UInt32{
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            var colorAsUInt : UInt32 = 0
            colorAsUInt += UInt32(red * 255.0) << 16 +
                UInt32(green * 255.0) << 8 +
                UInt32(blue * 255.0)
            return colorAsUInt
        }
        return 0xCC6699
    }
}
extension UIColor {
    
    // Create a UIColor from RGB
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    // Create a UIColor from a hex value (E.g 0x000000)
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}
