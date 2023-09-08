//
//  LoginVC.swift
//  Dietness
//
//  Created by karim metawea on 2/12/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import ScrollableSegmentedControl

class LoginVC: UIViewController {

    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var mailtextField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordTextField: JVFloatLabeledTextField!
    @IBOutlet weak var phoneTextField: JVFloatLabeledTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var backBtnOutlet: UIButton!
    @IBOutlet weak var signUpView: BorderdView!
    
    var type:String = "email"
    var code:String = "965"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegmented()
        segmentedControl.selectedSegmentIndex = 0
        if SettingsManager.manager.getSelectedPackage() == nil {
            self.signUpView.isHidden = true
        }

        print(SettingsManager.manager.getSelectedPackage())
    }
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
        
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
    
    
    func login(){
        self.view.makeToastActivity(.center)
        Connect.default.request(RegisterationConnector.login(loginData:type == "email" ? (mailtextField.text ?? ""):(phoneTextField.text ?? ""), password: passwordTextField.text ?? "", code:type == "email" ? nil:code, type: type)).decoded(toType: LoginResponse.self).observe { (result) in
            self.view.hideToastActivity()
            switch result{
            case .success(let data):
                if let result = data.result{
                    let setting = SettingsManager()
                    setting.updateUser(user: result.user)
                    setting.setUserToken(value: result.token ?? "")
                    setting.setSubiscribtion(value: result.current_subscription)
                    setting.setCurrentStatus(value:result.user?.status)
                    self.handleLoginStatus(user: result.user)
                }else{
                    self.view.makeToast(data.message)
                }
            case .failure(let error):
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    
    func handleLoginStatus(user:User?){
        
        switch user?.status {
        case "New","Pending":
            let vc:OtpVC = OtpVC.instantiate(appStoryboard: .login)
            vc.phoneCode = user?.country_code ?? ""
            vc.phone = user?.mobile ?? ""
            vc.email = user?.email ?? ""
            vc.type = self.type
            vc.comingFrom = "signup"
            vc.status = user?.status ?? "New"
            self.navigationController?.pushViewController(vc, animated: true)
        case "Waiting_payment":
            if let _ = SettingsManager.manager.getSelectedPackage() , let _ = SettingsManager.manager.getSelectedPlan(){
                let vc:PaymentVC = PaymentVC.instantiate(appStoryboard: .login)
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.view.makeToast("please select a plan to continue your payment")
            }
            
        case "Active":
            let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
            let vc = UIStoryboard(name: "Tab", bundle: nil).instantiateInitialViewController()
            rootviewcontroller.rootViewController = vc
            rootviewcontroller.makeKeyAndVisible()

        default:
            return
        }
    }
    
    
    @IBAction func login(_ sender: Any) {
        login()
    }
    @IBAction func bckBtnAction(_ sender: Any) {
        SettingsManager().setSelectedPlan(value:nil)
        SettingsManager.manager.setSelectedPackage(value: nil)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func countryCodeButton(_ sender: Any) {
        let vc:ChooseCountryCodeVC = ChooseCountryCodeVC.instantiate(appStoryboard: .login)
        vc.didSelectCountry = {[weak self] (country)in
            self?.countryCodeButton.setTitle( country.dialCode, for: .normal)
            self?.code = country.dialCode.replacingOccurrences(of: "+", with: "")
        }
        self.present(vc, animated: true, completion: nil)
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
    
    @IBAction func showPassword(_ sender: Any) {
    passwordTextField.isSecureTextEntry.toggle()
    }
    
    
}
