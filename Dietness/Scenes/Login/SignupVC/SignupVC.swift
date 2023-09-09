//
//  SignupVC.swift
//  Dietness
//
//  Created by karim metawea on 2/12/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit
import StepIndicator



// 1- sign up data
// 2- user info
// 3- sports target



class SignupVC: UIViewController {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var countryCodeButton: UIButton!

    var code = "966"
    var note = ""
    var autoActive = false
    var showDeliverySwitch = false
    
    
    var planId: Int?
    var sportingGoalId: Int?
    
    
    @IBOutlet weak var stepIndicator: StepIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRules()
    }
    
    
//    func shortcutToCompleteDesign(){
//        let vc:AddressVC = AddressVC.instantiate(appStoryboard: .popUps)
//        vc.new = true
//        vc.showDeliverySwitch = self.showDeliverySwitch
//        vc.note = self.note
//
//        vc.didAddAddress = { [weak self] in
//            let otpVC:OtpVC = OtpVC.instantiate(appStoryboard: .login)
//            otpVC.comingFrom = "signup"
//            otpVC.type = "email"
//            otpVC.email = self?.emailTextField.text ?? ""
//            otpVC.autoActive = self?.autoActive
//            self?.navigationController?.pushViewController(otpVC, animated: true)
//        }
//
//        self.present(vc, animated: true, completion: nil)
//    }

    
    func getRules(){
        self.view.makeToastActivity(.center)
        Connect.default.request(MainConnector.setting).decoded(toType: Setting.self).observe { (result) in
            self.view.hideToastActivity()
            switch result{
            case .success(let data):
                if let result = data.result {
                    if result.skip_activation == "on" {
                        self.autoActive = true
                    }
                    if result.enable_delievery_timeframes == "on" {
                        self.showDeliverySwitch = true
                    }
                    self.note = result.delivery_notes ?? ""
                }
            case .failure(let error):
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    
    func showSportsTargetScreen(){
        
        let sportsTargetVc = SportsTargetVC.instantiate(appStoryboard: .main) as! SportsTargetVC
        
        sportsTargetVc.choseSportsTargetCompletion = { [weak self] vc , targetId in
            
            vc.dismiss(animated: true)
            
            self?.sportingGoalId = targetId
            
            print(targetId, "tar idddd")
        }
    
        self.present(sportsTargetVc, animated: true, completion: nil)
    }
    
    
    // MARK: Actions
    @IBAction func signup(_ sender: Any) {
//        signup()
        
        showSportsTargetScreen()
        
    }
    @IBAction func loginBtnAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func showpassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    @IBAction func showconfirmPassword(_ sender: Any) {
        confirmPasswordTextField.isSecureTextEntry.toggle()
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




