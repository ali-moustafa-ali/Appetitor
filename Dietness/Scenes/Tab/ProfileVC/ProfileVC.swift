//
//  ProfileVC.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/15/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit
import FirebaseMessaging

class ProfileVC: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var noOfBoxes: UILabel!
    @IBOutlet weak var leftoverLabel: UILabel!
    @IBOutlet weak var startingAtLabel: UILabel!
    @IBOutlet weak var renewalBtnOutlet: UIButton!
    @IBOutlet weak var menuBtnOutlet: UIButton!
    
    var boxes: Int?
    var duration: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRemainingBoxes()
        self.userNameLabel.text = "\(SettingsManager.init().getFirstName()) \(SettingsManager.init().getLastName())"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Messaging.messaging().subscribe(toTopic: "all") { error in
            print("Subscribed to all topic")
        }
        // Do any additional setup after loading the view.
    }
    func getRemainingBoxes() {
        self.view.makeToastActivity(.center)
        Connect.default.request(TabConnector.getRemainingBoxes).decoded(toType: RemainingBoxesResponse.self).observe { (result) in
            self.view.hideToastActivity()
            switch result {
            case .success(let data):
                print("boxes success")
                self.boxes = data.result?.days ?? 0
                DispatchQueue.main.async {
                    self.noOfBoxes.text = "\(self.boxes ?? 0)"
                    let dateFromString = data.result?.from ?? ""
                    let dateToString = data.result?.to ?? ""
                    let dateFrom = dateFromString.dropLast(17)
                    let dateTo = dateToString.dropLast(17)
                    print("Date: \(dateFrom) / \(dateTo)")
                    self.duration = "Starting from \(dateFrom) to \(dateTo)"
                    self.startingAtLabel.text = "\(self.duration ?? "")"
                }
            case .failure(let error):
                print("boxes failed")
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    @IBAction func menuBtnAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    @IBAction func renewalBtnAction(_ sender: Any) {
        let popUpStoryBoards = UIStoryboard(name: "PopUps", bundle: nil)
        let vc = popUpStoryBoards.instantiateViewController(identifier: "ContactVC") as! ContactVC
        self.present(vc, animated: true, completion: nil)
    }
}
