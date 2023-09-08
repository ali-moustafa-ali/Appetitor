//
//  RenewalVC.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/17/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit

class ContactVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var contactBtnOutlet: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
     getContactNumber()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    func getContactNumber() {
           self.view.makeToastActivity(.center)
           Connect.default.request(TabConnector.contact).decoded(toType: ContactResponse.self).observe { (result) in
               self.view.hideToastActivity()
               switch result {
                   
               case .success(let data):
                   print("contact success")
                   
                   DispatchQueue.main.async {
                    self.phoneLabel.text = "\(data.result?.contact_mobile ?? "")"

                   }
               case .failure(let error):
                   print("contact failed")
                   self.view.makeToast(error.localizedDescription)
               }
           }
       }
    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func contactBtnAction(_ sender: Any) {
//        dialNumber(number: "\(phoneLabel.text ?? "")")
        let urlWhats = "https://wa.me/\(phoneLabel.text ?? "")"
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
    
}
