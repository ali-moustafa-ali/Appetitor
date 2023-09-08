//
//  NewPasswordVC.swift
//  Dietness
//
//  Created by karim metawea on 2/23/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class NewPasswordVC: UIViewController {
    
    
    
    @IBOutlet weak var passwordField: JVFloatLabeledTextField!
    @IBOutlet weak var confirmPasswordField: JVFloatLabeledTextField!
    @IBOutlet weak var confirmBtnOutlet: UIButton!

    
    var otp:String?
    var emailOrPhone:String?
    var code:String?
    var type:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func changePassword(){
        self.view.makeToastActivity(.center)
        Connect.default.request(RegisterationConnector.changePasswordWithForgot(otp: otp ?? "", emailOrMobile: emailOrPhone ?? "", type: type ?? "", code: code ?? "", password: passwordField.text ?? "")).decoded(toType: OtpForgetResponse.self).observe { (result) in
            self.view.hideToastActivity()
            switch result{
            case .success(_):
                self.view.makeToast("Password Changed Successfully".localized)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dismissViewControllers()
                }
            case .failure(let error):
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    
    func dismissViewControllers() {
    performSegue(withIdentifier: "backToLogin", sender: nil)
    }
    
    
    @IBAction func confirmBtnAction(_ sender: Any) {
           if  passwordField.text == "" || confirmPasswordField.text == "" {
               self.view.makeToast("Please complete all fields")
           }else if confirmPasswordField.text != passwordField.text {
               self.view.makeToast("Password mismatching")
           }else {
               changePassword()
           }
           
       }
       @IBAction func showConfirmBtn(_ sender: Any) {
        confirmPasswordField.isSecureTextEntry.toggle()
       }
       @IBAction func showPassword(_ sender: Any) {
        passwordField.isSecureTextEntry.toggle()
       }
    

}
