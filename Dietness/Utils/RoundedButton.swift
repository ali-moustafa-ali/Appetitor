//
//  RoundedButton.swift
//  Curex
//
//  Created by Diaa SAlAm on 1/3/20.
//  Copyright © 2020 Diaa SAlAm. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadius)
//        refreshBorderColor(color: borderColor)
        refreshBorder(width: borderWidth)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    func refreshBorder(width: CGFloat) {
        layer.borderWidth = width
    }
    
    func refreshBorderColor(color : CGColor) {
        layer.borderColor = color
    }
    
//    @IBInspectable var cornerRadius: CGFloat = 20 {
//        didSet {
//            refreshCorners(value: cornerRadius)
//        }
//    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            refreshBorder(width: borderWidth)
        }
    }
    
//    @IBInspectable var borderColor: CGColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1) {
//        didSet {
//            refreshBorderColor(color: borderColor)
//        }
//    }
    
}



