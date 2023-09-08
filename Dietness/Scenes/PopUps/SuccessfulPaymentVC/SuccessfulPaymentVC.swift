//
//  SuccessfulPaymentVC.swift
//  Dietness
//
//  Created by karim metawea on 2/24/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit

class SuccessfulPaymentVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
            let vc = UIStoryboard(name: "Tab", bundle: nil).instantiateInitialViewController()
            rootviewcontroller.rootViewController = vc
            rootviewcontroller.makeKeyAndVisible()
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
