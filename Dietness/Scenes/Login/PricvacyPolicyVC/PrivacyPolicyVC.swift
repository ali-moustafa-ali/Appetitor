//
//  PrivacyPolicyVC.swift
//  Dietness
//
//  Created by karim metawea on 2/23/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit


class PrivacyPolicyVC: UIViewController {

    @IBOutlet weak var policyView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        policyView.text = "...".localized
        // Do any additional setup after loading the view.
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
