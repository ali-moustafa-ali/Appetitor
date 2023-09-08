//
//  PasswordVC.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/17/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class PasswordVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var oldPasswordField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordField: JVFloatLabeledTextField!
    @IBOutlet weak var confirmPasswordField: JVFloatLabeledTextField!
    @IBOutlet weak var confirmBtnOutlet: UIButton!
    
    var oldBool = false
    var passBool = false
    var confirmBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    func changePassword(){
        self.view.makeToastActivity(.center)
        Connect.default.request(TabConnector.updatePassword(oldPassword: oldPasswordField.text ?? "", password: passwordField.text ?? "", confirmPassword: confirmPasswordField.text ?? "")).decoded(toType: DefaultResponse.self).observe { (result) in
            self.view.hideToastActivity()
            switch result{
            case .success(let data):
                print("password success")
                
                if data.error_flag == 0 {
                DispatchQueue.main.async {
                    self.view.makeToast(data.result?.message ?? "Password Changed Successfully".localized)
                    self.oldPasswordField.text = ""
                    self.passwordField.text = ""
                    self.confirmPasswordField.text = ""
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.dismiss(animated: true, completion: nil)
                }
                }else {
                    self.view.makeToast(data.result?.message ?? "Password Change Failed".localized)
                }
                
            case .failure(let error):
                print("password failed")
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    
    @IBAction func confirmBtnAction(_ sender: Any) {
        if oldPasswordField.text == "" || passwordField.text == "" || confirmPasswordField.text == "" {
            self.view.makeToast("Please complete all fields")
        }else if confirmPasswordField.text != passwordField.text {
            self.view.makeToast("Password mismatching")
        }else {
            changePassword()
        }
        
    }
    @IBAction func showConfirmBtn(_ sender: Any) {
        if confirmBool == false {
            confirmBool = true
            confirmPasswordField.isSecureTextEntry = false
        }else {
            confirmBool = false
            confirmPasswordField.isSecureTextEntry = true
        }
    }
    @IBAction func showPassword(_ sender: Any) {
        if passBool == false {
            passBool = true
            passwordField.isSecureTextEntry = false
        }else {
            passBool = false
            passwordField.isSecureTextEntry = true
        }
    }
    @IBAction func showOldPassword(_ sender: Any) {
        if oldBool == false {
            oldBool = true
            oldPasswordField.isSecureTextEntry = false
        }else {
            oldBool = false
            oldPasswordField.isSecureTextEntry = true
        }
    }
    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
