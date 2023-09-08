//
//  SignupVC.swift
//  Dietness
//
//  Created by karim metawea on 2/12/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit
import StepIndicator

class SignupVC: UIViewController {
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var countryCodeButton: UIButton!

    var code = "965"
    var note = ""
    var autoActive = false
    var showDeliverySwitch = false

    
    @IBOutlet weak var stepIndicator: StepIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getRules()
        // Do any additional setup after loading the view.
    }
    func signup(){
        self.view.makeToastActivity(.center)
        Connect.default.request(RegisterationConnector.signup(name: fullNameTextField.text ?? "", mobile: phoneTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField.text ?? "" , code: code)).decoded(toType: SignUpResponse.self).observe { (result) in
            self.view.hideToastActivity()
            switch result{
            case .success(let data):
                if let result = data.result{
                    let setting = SettingsManager()
                    setting.updateUser(user: result.user)
                    setting.setUserToken(value: result.token ?? "")
                    print("user token : \(SettingsManager.init().getUserToken())")
                    let vc:AddressVC = AddressVC.instantiate(appStoryboard: .popUps)
                    vc.new = true
                    vc.showDeliverySwitch = self.showDeliverySwitch
                    vc.note = self.note
                    vc.didAddAddress = { [weak self] in
                        let otpVC:OtpVC = OtpVC.instantiate(appStoryboard: .login)
                        otpVC.comingFrom = "signup"
                        otpVC.type = "email"
                        otpVC.email = self?.emailTextField.text ?? ""
                        otpVC.autoActive = self?.autoActive
                        self?.navigationController?.pushViewController(otpVC, animated: true)
                    }
                    self.present(vc, animated: true, completion: nil)
                }else{
                    self.view.makeToast(data.message)
                }
            case .failure(let error):
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
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
    
    
    @IBAction func signup(_ sender: Any) {
        signup()
        
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
