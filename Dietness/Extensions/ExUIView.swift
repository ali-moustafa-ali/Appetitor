//
//  ExUIView.swift
//  Curex
//
//  Created by Diaa SAlAm on 1/3/20.
//  Copyright © 2020 Diaa SAlAm. All rights reserved.
//

import UIKit

class Bind<T> {
    typealias Listener = (T?) -> Void
    var listener : Listener?
    var value : T? {
        didSet {
            listener?(value)
        }
    }
    init(_ value : T?) {
        self.value = value
    }
    func bind(listener : Listener?) {
        self.listener = listener
        listener?(value)
    }
}
extension UIScrollView {

    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }

    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }

}
extension UIView {
    
    func applyGradientBT(colours: [UIColor]) -> Void {
        self.applyGradientBT(colours: colours, locations: nil)
    }
    
    
    
    func applyGradientBT(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.frame = bounds
        gradient.cornerRadius = self.frame.size.height / 2
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    
    func applyGradientView(colours: [UIColor]) -> Void {
        self.applyGradientView(colours: colours, locations: [0.0, 0.90])
    }
    
    
    
    func applyGradientView(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.3)
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.frame = self.frame
        gradient.cornerRadius = 10
        gradient.masksToBounds = true
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func dropShadow(
        cornerRadius: CGFloat = 10,
        shadowRadius: CGFloat = 5,
        shadowColor: CGColor = UIColor.lightGray.cgColor,
        shadowOpacity: Float = 0.3,
        offsetWidth: CGFloat = 1,
        offsetHeight: CGFloat = 0) {
        backgroundColor = .white
        layer.cornerRadius = cornerRadius
        layer.shadowOffset = CGSize(width: offsetWidth, height: offsetHeight)
        layer.shadowColor = shadowColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        let shadowFrame: CGRect = layer.bounds
        let shadowPath: CGPath = UIBezierPath(rect: shadowFrame).cgPath
        layer.shadowPath = shadowPath
    }
    
    func roundCorners(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
    }
    
    func roundOneCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func applyShadow() {
        self.layer.shadowOpacity = 0.5
        self.layer.cornerRadius = 4.0
        self.layer.shadowRadius = 4.0
        self.layer.shadowOffset = CGSize(width: 1, height: 3)
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50).cgColor
        self.clipsToBounds = false
    }
    
    func addImageField(named: String, field: UITextField) {
        let paddingViewRight = UIView(frame: CGRect(x: -10, y: 0, width: 13, height: 8))
        let image = UIImageView(image: UIImage(named: named))
        image.frame = CGRect(x: -10, y: 0, width: 13, height: 8)
        
        paddingViewRight.addSubview(image)
        field.rightViewMode = .always
        field.rightView = paddingViewRight
        
    }
    
    func chainAnimtions(titleLabel: UILabel, withDuration: Double ) {
        print("V handleTapAnimations")
        
        UIView.animate(withDuration: withDuration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut, animations: {
                        
                        titleLabel.transform = CGAffineTransform(translationX: -30, y: 0)
                        
        }) { _ in
            UIView.animate(withDuration: withDuration,
                           delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                            titleLabel.alpha = 0
                            titleLabel.transform =      titleLabel.transform.translatedBy(x: 0, y: -200)
                            
            })
        }
        
    }
    
    func setRingProgressBar(progressView: UIView){
        let shapeLayer = CAShapeLayer()
        let center = progressView.center
        
        // create my track layer
        let trackLayer = CAShapeLayer()
        let halfSize:CGFloat = min( self.bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat = 1
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x:halfSize,y:halfSize),
            radius: CGFloat( halfSize - (desiredLineWidth/2) ),
            startAngle: CGFloat(0),
            endAngle:CGFloat(M_PI * 2),
            clockwise: true)
        
        //UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.white.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        progressView.layer.addSublayer(trackLayer)
        
        //        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = #colorLiteral(red: 0.9254901961, green: 0.5960784314, blue: 0.3176470588, alpha: 1)
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.strokeEnd = 0
        
        progressView.layer.addSublayer(shapeLayer)
        
        handleTap(shapeLayer: shapeLayer)
    }
    
    private func handleTap(shapeLayer: CAShapeLayer) {
        print("Attempting to animate stroke")
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 0.7
        
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
}

extension UILabel{
func setTextWhileKeepingAttributes(_ string: String) {
        if let attributedText = self.attributedText {
            let attributedString = NSMutableAttributedString(string: string,
                                                             attributes: [NSAttributedString.Key.font: font])
            attributedText.enumerateAttribute(.font, in: NSRange(location: 0, length: attributedText.length)) { (value, range, stop) in
                let attributes = attributedText.attributes(at: range.location, effectiveRange: nil)
                attributedString.addAttributes(attributes, range: range)
            }
            self.attributedText = attributedString
        }
    }
}


@IBDesignable class BorderdView: UIView {
//    @IBInspectable var borderColor: UIColor? {
//        set {
//            layer.borderColor = newValue?.cgColor
//        }
//        get {
//            guard let color = layer.borderColor else {
//                return nil
//            }
//            return UIColor(cgColor: color)
//        }
//    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
//    @IBInspectable var cornerRadius: CGFloat {
//        set {
//            layer.cornerRadius = newValue
//            clipsToBounds = newValue > 0
//        }
//        get {
//            return layer.cornerRadius
//        }
//    }
}

extension UIView {

fileprivate struct AssociatedObjectKeys {
    static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
}

fileprivate typealias Action = (() -> Void)?


fileprivate var tapGestureRecognizerAction: Action? {
    set {
        if let newValue = newValue {
            // Computed properties get stored as associated objects
            objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    get {
        let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
        return tapGestureRecognizerActionInstance
    }
}


public func addTapGestureRecognizer(action: (() -> Void)?) {
    self.isUserInteractionEnabled = true
    self.tapGestureRecognizerAction = action
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
    self.addGestureRecognizer(tapGestureRecognizer)
}


@objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
    if let action = self.tapGestureRecognizerAction {
        action?()
    } else {
        print("no action")
    }
}

}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        let radians = CGFloat.pi / 4
        rotateAnimation.fromValue = radians
        rotateAnimation.toValue = radians + .pi
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
