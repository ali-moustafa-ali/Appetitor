//
//  ForgotPasswordVC.swift
//  Dietness
//
//  Created by karim metawea on 2/13/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl


class ForgotPasswordVC: UIViewController {
    
    
    @IBOutlet weak var mailtextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var countryCodeButton: UIButton!

    
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!


    var type:String = "email"
    var code:String = "966"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegmented()
        segmentedControl.selectedSegmentIndex = 0

        // Do any additional setup after loading the view.
    }
    
    
    func configureSegmented(){
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: "Email Address".localized, at: 0)
        segmentedControl.insertSegment(withTitle: "Phone Number".localized, at: 1)

        segmentedControl.underlineSelected = true
        // change some colors
        segmentedControl.segmentContentColor = UIColor.gray
        segmentedControl.selectedSegmentContentColor = UIColor.PrimaryColor
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Cairo-Regular", size: 17)!,], for: .normal)
        // Turn off all segments been fixed/equal width.
        // The width of each segment would be based on the text length and font size.
        segmentedControl.fixedSegmentWidth = true
    }
    
    
    
    
    @IBAction func changedType(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0{
            type = "email"
            phoneTextField.superview?.isHidden = true
            mailtextField.superview?.isHidden = false
        }
        if segmentedControl.selectedSegmentIndex == 1{
            type = "phone"
            phoneTextField.superview?.isHidden = false
            mailtextField.superview?.isHidden = true
        }
    }
    
    
    
    
    @IBAction func confirm(_ sender: Any) {
        
        
        mailtextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        
        self.view.makeToastActivity(.center)
        Connect.default.request(RegisterationConnector.forgotPassword(emailOrMobile: type == "email" ? (mailtextField.text ?? ""):(phoneTextField.text ?? ""), type: type, code:type == "email" ? nil:code )).decoded(toType: DefaultResponse.self).observe { (result) in
            self.view.hideToastActivity()
            switch result{
            case .success(let data):
                if data.error_flag == 0 {
                if let result = data.result{
                    self.view.makeToast(data.result?.message ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    let vc:OtpVC = OtpVC.instantiate(appStoryboard: .login)
                    vc.comingFrom = "forgotPassword"
                    vc.email = self.mailtextField.text ?? ""
                    vc.type = self.type
                    vc.phoneCode = self.code
                    self.show(vc, sender: nil)
                    }
                }
                }else{
                    self.view.makeToast(data.message)
                }
            case .failure(let error):
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    
    @IBAction func changeCountryCode(_ sender: Any) {
        let vc:ChooseCountryCodeVC = ChooseCountryCodeVC.instantiate(appStoryboard: .login)
        vc.didSelectCountry = {[weak self] (country)in
            self?.countryCodeButton.setTitle( country.dialCode, for: .normal)
            self?.code = country.dialCode.replacingOccurrences(of: "+", with: "")
        }
        self.present(vc, animated: true, completion: nil)
    }

    
    

}
