//
//  ViewExtension.swift
// Tatx
//
//  Created by Mohammed Ragab on 13/05/2020.
//  Copyright © 2020 International Applications. All rights reserved.
//

import UIKit

enum Transition {
    
    case top
    case bottom
    case right
    case left
    
    var type : String {
        
        switch self {
            
        case .top :
            return convertFromCATransitionSubtype(CATransitionSubtype.fromBottom)
        case .bottom :
            return convertFromCATransitionSubtype(CATransitionSubtype.fromTop)
        case .right :
            return convertFromCATransitionSubtype(CATransitionSubtype.fromLeft)
        case .left :
            return convertFromCATransitionSubtype(CATransitionSubtype.fromRight)
            
        }
        
    }
    
}
func dialNumber(number : String) {

 if let url = URL(string: "tel://\(number)"),
   UIApplication.shared.canOpenURL(url) {
      if #available(iOS 10, *) {
        UIApplication.shared.open(url, options: [:], completionHandler:nil)
       } else {
           UIApplication.shared.openURL(url)
       }
   } else {
            // add error message here
   }
}
extension Date {
    static func getFormattedDate(string: String , formatter:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"

        let date: Date? = dateFormatterGet.date(from: "2018-02-01T19:10:04+00:00")
        print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
        return dateFormatterPrint.string(from: date!);
    }
}
fileprivate var viewBackground : UIView? // Background view object
extension UIView {
    
    enum ViewSide {
        case top
        case right
        case bottom
        case left
    }
    
    func createBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) -> CALayer {
        
        switch side {
        case .top:
            // Bottom Offset Has No Effect
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: 0 + topOffset,
                                                    width: self.frame.size.width - leftOffset - rightOffset,
                                                    height: thickness), color: color)
        case .right:
            // Left Has No Effect
            // Subtract bottomOffset from the height to get our end.
            return _getOneSidedBorder(frame: CGRect(x: self.frame.size.width - thickness - rightOffset,
                                                    y: 0 + topOffset,
                                                    width: thickness,
                                                    height: self.frame.size.height), color: color)
        case .bottom:
            // Top has No Effect
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: self.frame.size.height-thickness-bottomOffset,
                                                    width: self.frame.size.width - leftOffset - rightOffset,
                                                    height: thickness), color: color)
        case .left:
            // Right Has No Effect
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: 0 + topOffset,
                                                    width: thickness,
                                                    height: self.frame.size.height - topOffset - bottomOffset), color: color)
        }
    }
    
    func createViewBackedBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) -> UIView {
        
        switch side {
        case .top:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                              y: 0 + topOffset,
                                                              width: self.frame.size.width - leftOffset - rightOffset,
                                                              height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            return border
            
        case .right:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                                              y: 0 + topOffset, width: thickness,
                                                              height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            return border
            
        case .bottom:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                              y: self.frame.size.height-thickness-bottomOffset,
                                                              width: self.frame.size.width - leftOffset - rightOffset,
                                                              height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            return border
            
        case .left:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            return border
        }
    }
    
    func addBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        
        switch side {
        case .top:
            // Add leftOffset to our X to get start X position.
            // Add topOffset to Y to get start Y position
            // Subtract left offset from width to negate shifting from leftOffset.
            // Subtract rightoffset from width to set end X and Width.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                             y: 0 + topOffset,
                                             width: self.frame.size.width - leftOffset - rightOffset,
                                             height: thickness), color: color)
            self.layer.addSublayer(border)
        case .right:
            // Subtract the rightOffset from our width + thickness to get our final x position.
            // Add topOffset to our y to get our start y position.
            // Subtract topOffset from our height, so our border doesn't extend past teh view.
            // Subtract bottomOffset from the height to get our end.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                             y: 0 + topOffset, width: thickness,
                                             height: self.frame.size.height - topOffset - bottomOffset), color: color)
            self.layer.addSublayer(border)
        case .bottom:
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                             y: self.frame.size.height-thickness-bottomOffset,
                                             width: self.frame.size.width - leftOffset - rightOffset, height: thickness), color: color)
            self.layer.addSublayer(border)
        case .left:
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                             y: 0 + topOffset,
                                             width: thickness,
                                             height: self.frame.size.height - topOffset - bottomOffset), color: color)
            self.layer.addSublayer(border)
        }
    }
    
    func addViewBackedBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        
        switch side {
        case .top:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                       y: 0 + topOffset,
                                                       width: self.frame.size.width - leftOffset - rightOffset,
                                                       height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            self.addSubview(border)
            
        case .right:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                                       y: 0 + topOffset, width: thickness,
                                                       height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            self.addSubview(border)
            
        case .bottom:
             let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                        y: self.frame.size.height-thickness-bottomOffset,
                                                        width: self.frame.size.width - leftOffset - rightOffset,
                                                        height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            self.addSubview(border)
        case .left:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                       y: 0 + topOffset,
                                                       width: thickness,
                                                       height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            self.addSubview(border)
        }
    }
    
    //////////
    // Private: Our methods call these to add their borders.
    //////////
    
    
    fileprivate func _getOneSidedBorder(frame: CGRect, color: UIColor) -> CALayer {
        let border:CALayer = CALayer()
        border.frame = frame
        border.backgroundColor = color.cgColor
        return border
    }
    
    fileprivate func _getViewBackedOneSidedBorder(frame: CGRect, color: UIColor) -> UIView {
        let border:UIView = UIView.init(frame: frame)
        border.backgroundColor = color
        return border
    }
    
}

extension UIView {
    @discardableResult   // 1
    func fromNib<T : UIView>() -> T? {   // 2
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            return nil
        }
        self.addSubview(contentView)     // 4
        contentView.translatesAutoresizingMaskIntoConstraints = false   // 5
//        contentView.layoutAttachAll(to: self)   // 6
        return contentView   // 7
    }
    @IBInspectable
    var bottomBorder : UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor)
        }
        set(newValue) {
            self.layer.backgroundColor = UIColor.white.cgColor
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.lightGray.cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 0.1)
            self.layer.shadowOpacity = 1.0
            self.layer.shadowRadius = 0.0
        }
    }
   
    func removeBorder() {
      self.layer.borderColor = UIColor.clear.cgColor
      self.layer.borderWidth = 0
    }
    func setWhiteBottomBorder() {
      self.layer.backgroundColor = UIColor.white.cgColor
      self.layer.masksToBounds = false
      self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.1)
      self.layer.shadowOpacity = 1.0
      self.layer.shadowRadius = 0.0
    }
    func setRedBottomBorder() {
      self.layer.backgroundColor = #colorLiteral(red: 0.9230852723, green: 0.136062324, blue: 0.3258422017, alpha: 1)
      self.layer.masksToBounds = false
      self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.1)
      self.layer.shadowOpacity = 1.0
      self.layer.shadowRadius = 0.0
    }
    func addImage(_ imagename: String) -> UIView {
        let image : UIImage = UIImage(named: imagename) ?? UIImage()
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }
    
    func show(with transition : Transition, duration : CFTimeInterval = 0.5, completion : (()->())?) {
        
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = convertToOptionalCATransitionSubtype(transition.type)
        animation.duration = duration
       
        self.layer.add(animation, forKey: convertFromCATransitionType(CATransitionType.push))
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?()
        }
    }
    
    // MARK:- Dismiss view
    
    func dismissView(with duration : TimeInterval = 0.3, onCompletion completion : (()->Void)?){
        
        UIView.animate(withDuration: duration, animations: {
            self.frame.origin.y += self.frame.height
        }) { (_) in
            self.removeFromSuperview()
            completion?()
        }
    }
    
    
    func dismissKeyBoardonTap(){
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.endEditingForce)))
        
    }
    
   @IBAction func endEditingForce(){
        
        self.endEditing(true)
        
    }
    
    
    // Hide and show in Dispatch Main thread
    
    func isHideInMainThread(_ isHide : Bool){
        
        DispatchQueue.main.async {
           
            if isHide {
                UIView.animate(withDuration: 0.1, animations: {
                     self.isHidden = isHide
                })
            } else {
                 self.isHidden = isHide
            }
            
        }
        
    }
    
    // Set Tint color
    
    @IBInspectable
    var tintColorId : Int {
        
        get {
           return self.tintColorId
        }
        set(newValue){
            self.tintColor = {
                
                if let color = Color.valueFor(id: newValue){
                    return color
                } else {
                    return tintColor
                }
                
            }()
        } 
    }
    
    
   //Set background color
    
    @IBInspectable
    var backgroundColorId : Int {
        
        get {
            return self.backgroundColorId
        }
        set(newValue){
            self.backgroundColor = {
                if let color = Color.valueFor(id: newValue){
                    return color
                } else {
                    return backgroundColor
                }
                
            }()
        }
        
    }
    
    //Setting Corner Radius
    
    @IBInspectable
    var cornerRadius : CGFloat {
        
        get{
          return self.layer.cornerRadius
        }
        
        set(newValue) {
            self.layer.cornerRadius = newValue
        }
        
    }
    
    
    //MARK:- Setting bottom Line
    
    @IBInspectable
    var borderLineWidth : CGFloat {
        get {
            return self.layer.borderWidth
        }
        set(newValue) {
            self.layer.borderWidth = newValue
        }
    }
    
    
    //MARK:- Setting border color
    
    @IBInspectable
    var borderColor : UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor)
        }
        set(newValue) {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    
    //MARK:- Shadow Offset
    
    @IBInspectable
    var offsetShadow : CGSize {
        
        get {
           return self.layer.shadowOffset
        }
        set(newValue) {
            self.layer.shadowOffset = newValue
        }
        
        
    }
    
    
    //MARK:- Shadow Opacity
    @IBInspectable
    var opacityShadow : Float {
        
        get{
            return self.layer.shadowOpacity
        }
        set(newValue) {
            self.layer.shadowOpacity = newValue
        }
        
    }
    
    //MARK:- Shadow Color
    @IBInspectable
    var colorShadow : UIColor? {
        
        get{
           return UIColor(cgColor: self.layer.shadowColor ?? UIColor.clear.cgColor)
        }
        set(newValue) {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    //MARK:- Shadow Radius
    @IBInspectable
    var radiusShadow : CGFloat {
        get {
             return self.layer.shadowRadius
        }
        set(newValue) {
            
           self.layer.shadowRadius = newValue
        }
    }
    
    //MARK:- Mask To Bounds
    
    @IBInspectable
    var maskToBounds : Bool {
        get {
            return self.layer.masksToBounds
        }
        set(newValue) {
            
            self.layer.masksToBounds = newValue
        }
    }
    
    
    //MARK:- Add Shadow with bezier path
    
    func addShadow(color : UIColor = .gray, opacity : Float = 0.5, offset : CGSize = CGSize(width: 0.5, height: 0.5), radius : CGFloat = 0.5, rasterize : Bool = true, maskToBounds : Bool = false){
        
        layer.masksToBounds = maskToBounds
        self.custom(layer: self.layer, opacity: opacity, offset: offset, color: color, radius: radius)
      //layer.shadowPath = UIBezierPath(rect: self.frame).cgPath
        layer.shouldRasterize = rasterize
        
    }
    
    //MARK:- Add shadow by beizer
    
    func addShadowBeizer(){
        
            
            let shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.width/2).cgPath
            shadowLayer.fillColor = UIColor.blue.cgColor
            shadowLayer.shadowPath = shadowLayer.path
        
          
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 4
            
            self.layer.insertSublayer(shadowLayer, at: 0)
      
        
    }
    
    
    private func custom(layer customLayer : CALayer, opacity : Float, offset : CGSize, color : UIColor, radius : CGFloat){
        
        customLayer.shadowColor = color.cgColor
        customLayer.shadowOpacity = opacity
        customLayer.shadowOffset = offset
        customLayer.shadowRadius = radius
        
        
    }
    
    //MARK:- Make View Round
    
    func makeRoundedCorner(){
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.width/2
        
    }
    
    //MARK:- Add Button Animation
    
    func addPressAnimation(with  duration : TimeInterval = 0.2 , transform : CGAffineTransform = CGAffineTransform(scaleX: 0.95, y: 0.95)) {
        
        UIView.animate(withDuration: duration, animations: {
            self.transform = transform
        }) { (bool) in
            UIView.animate(withDuration: duration, animations: {
                self.transform = .identity
            })
        }
    }
    
    // MARK:- Create Half Circle
    
    func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) ->CAShapeLayer{
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: self.bounds.width/2, startAngle: .pi, endAngle: 0 , clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
       // layer.lineWidth = 20
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
      //  layer.lineDashPhase
        layer.position = CGPoint(x: self.bounds.width/2, y: self.bounds.height)
       
        return layer
    }
    
    func showAnimateView(_ view: UIView, isShow: Bool, direction: Transition, duration : Float = 0.8 ) {
        if isShow {
            view.isHidden = false
            self.bringSubviewToFront(view)
            print(direction.type)
            pushTransition(CFTimeInterval(duration), view: view, withDirection: direction)
        }
        else {
            self.sendSubviewToBack(view)
            view.isHidden = true
            pushTransition(CFTimeInterval(duration), view: view, withDirection: direction)
        }
    }
    
    func pushTransition(_ duration: CFTimeInterval, view: UIView, withDirection direction: Transition) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = convertToOptionalCATransitionSubtype(direction.type)
        animation.duration = duration
        view.layer.add(animation, forKey: convertFromCATransitionType(CATransitionType.moveIn))
        
    }
    // Shake View
    func shake(){
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    // Add Background View for Nib files
    func addBackgroundView(in bgView : UIView, gesture : UITapGestureRecognizer){
        
        let viewSubject = UIView(frame: UIScreen.main.bounds)
        viewSubject.alpha = 0.0
        viewSubject.backgroundColor = .black
        bgView.addSubview(viewSubject)
        UIView.animate(withDuration: 1) {
            viewSubject.alpha = 0.4
        }
        viewBackground = viewSubject
        viewBackground?.addGestureRecognizer(gesture)
    }
    
    // Remove background View
    
    func removeBackgroundView() {
        UIView.animate(withDuration: 0.5, animations: {
            viewBackground?.alpha = 0
        }) { (_) in
            viewBackground?.removeFromSuperview()
        }
    }
    
    // MARK:- Add Dashed Line
    func addDashedLine() {
        let lineBorder = CAShapeLayer()
        lineBorder.strokeColor = UIColor.black.cgColor
        lineBorder.lineDashPattern = [4,4]
        lineBorder.frame = self.bounds
        lineBorder.fillColor = nil
        lineBorder.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(lineBorder)
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATransitionSubtype(_ input: CATransitionSubtype) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalCATransitionSubtype(_ input: String?) -> CATransitionSubtype? {
	guard let input = input else { return nil }
	return CATransitionSubtype(rawValue: input)
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATransitionType(_ input: CATransitionType) -> String {
	return input.rawValue
}
extension UIView {

    struct PinOptions: OptionSet {

        public let rawValue: Int

        public static let all: PinOptions = [.top, .trailing, .bottom, .leading]

        public static let top = PinOptions(rawValue: 1 << 0)
        public static let trailing = PinOptions(rawValue: 1 << 1)
        public static let bottom = PinOptions(rawValue: 1 << 2)
        public static let leading = PinOptions(rawValue: 1 << 3)

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    /// Add layout constraints. Also sets translatesAutoresizingMaskIntoConstraints to false.
    ///
    /// - Parameters:
    ///   - parentView: parent view
    ///   - edges: choose which edge to add
    func pinEdges(to parentView: UIView, edges: PinOptions = .all) {

        translatesAutoresizingMaskIntoConstraints = false
        if edges.contains(.leading) {
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        }

        if edges.contains(.trailing) {
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        }

        if edges.contains(.top) {
            topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        }

        if edges.contains(.bottom) {
            bottomAnchor.constraint(equalTo:parentView.bottomAnchor).isActive = true
        }
    }

    /// Add layout constraints. Also sets translatesAutoresizingMaskIntoConstraints to false.
    ///
    /// - Parameters:
    ///   - parentView: parent view
    ///   - edges: choose which edge to add
    func pinMargins(to parentView: UIView, edges: PinOptions = .all) {

        translatesAutoresizingMaskIntoConstraints = false
        if edges.contains(.leading) {
            leadingAnchor.constraint(equalTo: parentView.layoutMarginsGuide.leadingAnchor).isActive = true
        }

        if edges.contains(.trailing) {
            trailingAnchor.constraint(equalTo: parentView.layoutMarginsGuide.trailingAnchor).isActive = true
        }

        if edges.contains(.top) {
            topAnchor.constraint(equalTo: parentView.layoutMarginsGuide.topAnchor).isActive = true
        }

        if edges.contains(.bottom) {
            bottomAnchor.constraint(equalTo:parentView.layoutMarginsGuide.bottomAnchor).isActive = true
        }
    }

}
