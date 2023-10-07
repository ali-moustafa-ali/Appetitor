//
//  PackagePopUpVC.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/14/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit

class PackagePopUpVC: UIViewController {
    
    @IBOutlet weak var packageImage: UIImageView!
    @IBOutlet weak var packageName: UILabel!
    @IBOutlet weak var packagePrice: UILabel!
    @IBOutlet weak var subscribeBtnOutlet: UIButton!
    @IBOutlet weak var plansTableView: UITableView!
    
    var plans: [Plan] = []
    var imageURL = ""
    var package : Package?
    var name = ""
    var names : [String] = []
    var selectedPlan:Plan?
    var didTapSubscribe:((Int)->())?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeBtnOutlet.setTitle(NSLocalizedString("Subscribe", comment: ""), for: .normal)

        if let url = URL(string: imageURL) {
            print(url, "Ali")
            packageImage.sd_setImage(with: url, placeholderImage: UIImage(named: "default"))
        }
        packageName.text = package?.name
        plans = package?.plans ?? []
        print(plans.count)
        print(plans)
        
        var prices : [Double] = []
        for plan in plans {
            if prices.count <= plans.count {
                prices.append(Double(plan.price ?? "")!)
            }
            
        }
        let price = prices.reduce(0, +)
//        packagePrice.text = "\(plans.first?.price ?? "") R.S"
        packagePrice.text = "\(plans.first?.price ?? "") \(NSLocalizedString("SAR", comment: ""))"

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.plansTableView.reloadData()
        }
        
    }
    
    
    @IBAction func subscribeBtnAction(_ sender: Any) {
        
        
        if let selectedPlanId = selectedPlan?.id {
//            let storyboard = UIStoryboard(name: "Login", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
            
            self.dismiss(animated: false) {
                self.didTapSubscribe?(selectedPlanId)
            }
        }else {
//            self.view.makeToast("Please Choose plan")
            self.view.makeToast(NSLocalizedString("Please Choose plan", comment: "Choose Plan Message"))

        }
        
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
extension PackagePopUpVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath) as! PlanCell
        cell.planWeight.text = plans[indexPath.row].description
        names = []
        for cat in plans[indexPath.row].categories ?? [] {
            if names.count < plans[indexPath.row].categories?.count ?? 0 {
                names.append("\(cat.qty?.intValue ?? 0) \(cat.category?.name ?? "")")
            }
        }
        name = names.joined(separator: "+")
        cell.planDesc.text = "\(name)"
        cell.daysLabel.text = "\(plans[indexPath.row].days ?? "") \("days".localized)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPlan = plans[indexPath.row]
//        packagePrice.text = "\(plans[indexPath.row].price ?? "") R.S"
        packagePrice.text = "\(plans[indexPath.row].price ?? "") \(NSLocalizedString("SAR", comment: ""))"

        SettingsManager().setSelectedPlan(value:self.selectedPlan)
        SettingsManager.manager.setSelectedPackage(value: package)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
