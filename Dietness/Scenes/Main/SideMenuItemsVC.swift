//
//  SideMenuItemsVC.swift
//  Gaxa
//
//  Created by karim metawea on 5/14/20.
//  Copyright © 2020 Rami Suliman. All rights reserved.
//

import UIKit
import MOLH

class SideMenuItemsVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell
        if indexPath.row == 1 {
            cell.textLabel?.text = "Login".localized

            cell.imageView?.image = #imageLiteral(resourceName: "sign-out")
            cell.imageView?.tintColor = #colorLiteral(red: 0.9764656425, green: 0.7873547673, blue: 0.4655939341, alpha: 1)
        }
        if indexPath.row == 2 {
            
            cell.textLabel?.text = "عربي".localized
            cell.imageView?.image = UIImage(systemName: "globe")
            cell.imageView?.tintColor = #colorLiteral(red: 0.9764656425, green: 0.7873547673, blue: 0.4655939341, alpha: 1)
            
        }
        cell.textLabel?.font = UIFont(name: "Cairo-Bold", size: 17)
        cell.backgroundColor = #colorLiteral(red: 0.9489366412, green: 0.9490727782, blue: 0.9489067197, alpha: 1)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
//            let vc:LoginVC = LoginVC.instantiate(appStoryboard: .login)
//            self.present(vc, animated: true, completion: nil)
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 2 {
            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
            SettingsManager.manager.resetAccount()
            let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            rootviewcontroller.rootViewController = vc
            rootviewcontroller.makeKeyAndVisible()
//            MOLH.reset()
        }
        
    }
//        if indexPath.row == 7{
//            if let call =  SettingsManager().getOutlet()?.phone,
//                       let url = URL(string: "tel://\(call)"),
//                       UIApplication.shared.canOpenURL(url) {
//                       UIApplication.shared.open(url)
//            }else{
//                self.view.makeToast("no available phone for this outlet")
//            }
//        }
//        
//        if indexPath.row == 8 {
//            if let urlStr = URL(string: "https://apps.apple.com/us/app/id1533908670") {
//                let objectsToShare = [urlStr]
//                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//
//                if UIDevice.current.userInterfaceIdiom == .pad {
//                    if let popup = activityVC.popoverPresentationController {
//                        popup.sourceView = self.view
//                        popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
//                    }
//                }
//
//                self.present(activityVC, animated: true, completion: nil)
//            }
//        }
//    }

}
