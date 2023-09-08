//
//  SettingVC.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/15/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import MOLH

class SettingVC: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var basicInformationLabel: UILabel!
    @IBOutlet weak var langBtnOutlet: UIButton!
    @IBOutlet weak var nameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var phoneTextField: JVFloatLabeledTextField!
    @IBOutlet weak var emailTextField: JVFloatLabeledTextField!
    @IBOutlet weak var birthTextField: JVFloatLabeledTextField!
    @IBOutlet weak var addressBtnOutlet: UIButton!
    @IBOutlet weak var passwordBtnOutlet: UIButton!
    @IBOutlet weak var saveBtnOutlet: UIButton!
    @IBOutlet weak var logoutBtnOutlet: UIButton!
    var contactNo: String?
    var address : Address?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userNameLabel.text = "\(SettingsManager.init().getFirstName()) \(SettingsManager.init().getLastName())"
//         getProfile()
        getContactNumber()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getProfile()
    }
    func getProfile(){
           self.view.makeToastActivity(.center)
           Connect.default.request(TabConnector.getProfile).decoded(toType: ProfileResponse.self).observe { (result) in
               self.view.hideToastActivity()
               switch result{
               case .success(let data):
               print("profile success")
                if data.result?.profile?.address != nil {
                self.address = data.result?.profile?.address!
                }
               DispatchQueue.main.async {
                self.nameTextField.text = data.result?.profile?.name ?? ""
                self.phoneTextField.text = data.result?.profile?.mobile ?? ""
                self.emailTextField.text = data.result?.profile?.email ?? ""
                self.birthTextField.text = data.result?.profile?.birth ?? ""
                }
                
               case .failure(let error):
                  print("profile failed")
                  self.view.makeToast(error.localizedDescription)
               }
           }
       }
    func getContactNumber() {
           self.view.makeToastActivity(.center)
           Connect.default.request(TabConnector.contact).decoded(toType: ContactResponse.self).observe { (result) in
               self.view.hideToastActivity()
               switch result {
                   
               case .success(let data):
                   print("contact success")
                   
                self.contactNo = data.result?.contact_mobile ?? ""
               case .failure(let error):
                   print("contact failed")
                   self.view.makeToast(error.localizedDescription)
               }
           }
       }
    
    func updateProfile(){
        self.view.makeToastActivity(.center)
     Connect.default.request(TabConnector.updateProfile(name: nameTextField.text ?? "", email: emailTextField.text ?? "", country_code: "", mobile: phoneTextField.text ?? "", birth: birthTextField.text ?? "", status: "", deleted_at: "")).decoded(toType: DefaultResponse.self).observe { (result) in
            self.view.hideToastActivity()
            switch result{
            case .success(let data):
                if data.error_flag == 0 {
             print("updateProfile success")
                self.view.makeToast("Profile Updated Successfully".localized)
                }else {
                    self.view.makeToast("Error Update Profile".localized)

                }
            case .failure(let error):
             print("updateProfile failed")
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    @IBAction func contactBtnAction(_ sender: Any) {
//        dialNumber(number: contactNo ?? "")
        let urlWhats = "https://wa.me/\(contactNo ?? "")"
             if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                 if let whatsappURL = NSURL(string: urlString) {
                     if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                         UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: nil)
                     } else {
                         print("Cannot Open Whatsapp")
                     }
                 }
             }
    }
    
    @IBAction func addressBtnAction(_ sender: Any) {
        let popUpStoryBoards = UIStoryboard(name: "PopUps", bundle: nil)
        let vc = popUpStoryBoards.instantiateViewController(identifier: "AddressVC") as! AddressVC
        
        vc.modalPresentationStyle = .automatic
        vc.callbackClosure = { [weak self] in
            self?.getProfile()
        }
        vc.new = false
        vc.address = self.address
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func passwordBtnAction(_ sender: Any) {
        let popUpStoryBoards = UIStoryboard(name: "PopUps", bundle: nil)
        let vc = popUpStoryBoards.instantiateViewController(identifier: "PasswordVC") as! PasswordVC
        vc.modalPresentationStyle = .automatic
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func saveBtnAction(_ sender: Any) {
        updateProfile()
    }
    
    
    @IBAction func logout(_ sender: Any) {
        SettingsManager.manager.resetAccount()
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        rootviewcontroller.rootViewController = vc
        rootviewcontroller.makeKeyAndVisible()
    }
    
    @IBAction func languageBtnAction(_ sender: Any) {
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        MOLH.reset()
    }
    
}
