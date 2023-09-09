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

    var countryCode = "966"
    var note = ""
    var autoActive = false
    var showDeliverySwitch = false
    
    var signUpInformation = FullSignUpInformation()

    var planId: Int?
    
    @IBOutlet weak var stepIndicator: StepIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRules()
        
        // prepare
        
//        signUpInformation = FullSignUpInformation()

//        let userInformation = UserInformation(weight: "120", height: "212",
//                                              birth_date: "12-12-2022", gender: "1", food_system: "1",
//                                              allergen_id: ["4","5"], excluded_classifications: ["1","2"])
////
//        signUpInformation?.userInformation = userInformation
        
    }

    // MARK: Sign up
    func signup(){
        self.view.makeToastActivity(.center)
        
        guard let signUpInformationPara = signUpInformation.getParams() else {
    
            self.view.makeToast("some data are missing")
    
            return
        }
    
        Connect.default.request(RegisterationConnector
            .signup(dict: signUpInformationPara))
        .decoded(toType: SignUpResponse.self)
        .observe {
            [weak self] (result) in
            guard let self = self else{return}
            
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
                        
                        self?.stepIndicator.currentStep = 5
                        
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
    
    private func showSportsTargetScreen(){
        
        let sportsTargetVc = SportsTargetVC.instantiate(appStoryboard: .main) as! SportsTargetVC
        
        sportsTargetVc.choseSportsTargetCompletion = { [weak self] vc , targetId in
            
            vc.dismiss(animated: true)
            
            self?.signUpInformation.sportsTargetId = targetId
            
            //self.show

            self?.stepIndicator.currentStep = 3
            self?.showBodyInfoScreen()
            
            
            print(targetId, "tar idddd")
        }
    
        self.present(sportsTargetVc, animated: true, completion: nil)
    }
    
    
    private func showBodyInfoScreen(){
        
        let bodyInfoVC = BodyInfoVC(nibName: "BodyInfoVC", bundle: nil)
        
        bodyInfoVC.finishedBodyInfoCompletion = { [weak self] vc , userInfo in
            
            vc.dismiss(animated: true)
            
            self?.signUpInformation.userInformation = userInfo
              
            self?.stepIndicator.currentStep = 4
            
            //
            self?.signup()
            
            print(userInfo, "userInfo ")
        }
    
        self.present(bodyInfoVC, animated: true, completion: nil)
    }
    
    
    
    
    private func getSignUpInfo()->SignUpInfo?{
        
        if let fullName = fullNameTextField.text,
           let email = emailTextField.text,
           let phone = phoneTextField.text,
           let password = passwordTextField.text {
            
            return SignUpInfo(planId: planId,
                              name: fullName, mobile: phone,
                              email: email, password: password,
                              countryCode: countryCode)
        }
        
        return nil
    }
    
    
    private func checkVerification()->Bool{
        
        guard let fullName = fullNameTextField.text,
              fullName.count > 10 else{
            
            view.makeToast("Please enter full name")
            
            return false
        }
        
        guard let email = emailTextField.text,
                !email.isEmpty else{
            
            view.makeToast("Please enter email")
            
            return false
        }
        

        guard let phone = phoneTextField.text,
                !phone.isEmpty else{
            
            view.makeToast("Please enter phone")
            
            return false
        }
        
        guard let password = passwordTextField.text,
              password.count >= 6 else{
            
            view.makeToast("Password should be 6 characters or more")
            
            return false
        }
        
        guard let verifyPassword = confirmPasswordTextField.text,
              verifyPassword.count >= 6 else{
            
            view.makeToast("Confirm Password should be 6 characters or more")
            
            return false
        }
        
        return true

    }
    
    // MARK: Actions
    @IBAction func signup(_ sender: Any) {
        
        
        // 0
        guard checkVerification() else{
            
            return
        }
        
        
        // 1
        guard let signUpInfo = getSignUpInfo() else{
            
            view.makeToast("Please complete all required data")
            
            return
        }
        
        signUpInformation.signUpInfo = signUpInfo
        
        
        //2
        stepIndicator.currentStep = 2
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
        let vc = ChooseCountryCodeVC.instantiate(appStoryboard: .login) as! ChooseCountryCodeVC
        
        vc.didSelectCountry = { [weak self] (country)in
            self?.countryCodeButton.setTitle( country.dialCode, for: .normal)
            self?.countryCode = country.dialCode.replacingOccurrences(of: "+", with: "")
        }
        
        self.present(vc, animated: true, completion: nil)
    }
}




class SignUpInfo{
    // 0
    var planId: Int?
    
    var name: String?
    var mobile: String?
    var email: String?
    var password: String?
    var countryCode: String?
    
    init(planId: Int?,
         name: String?,
         mobile: String?,
         email: String?,
         password: String?,
         countryCode: String?
        ){
        self.planId = planId
        self.name = name
        self.mobile = mobile

        self.email = email
        self.password = password
        self.countryCode = countryCode

    }
    
    func getParams()-> [String: Any]{
                
        var para = [String: String]()
        
        //
        if let planId = planId{ para["planId"] = String(planId) }
                
        if let name = name{ para["name"] = name }
        
        if let mobile = mobile{ para["mobile"] = mobile }

        if let email = email{ para["email"] = email }

        if let password = password{
            para["password"] = password
            para["verify_password"] = password
        }

        if let countryCode = countryCode{ para["code"] = countryCode }

        if let name = name{ para["name"] = name }


        
        return para
    }
}
