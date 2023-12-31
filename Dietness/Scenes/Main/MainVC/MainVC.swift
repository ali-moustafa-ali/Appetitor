//
//  MainVC.swift
//  Dietness
//
//  Created by mohamed dorgham on 2/13/21.
//  Copyright © 2021 Dietness. All rights reserved.
//

import UIKit
import SDWebImage
import Closures
import SideMenu
import FirebaseMessaging

class MainVC: UIViewController {
    @IBOutlet weak var contdentView: UIView!
    
    @IBOutlet weak var pagerView: FSPagerView!{
        didSet {
            pagerView.delegate = self
            pagerView.dataSource = self
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = FSPagerView.automaticSize
            pagerView.automaticSlidingInterval = 2
            pagerView.decelerationDistance = 1
            pagerView.backgroundColor = .white
            pagerView.bounces = false
            pagerView.isInfinite = true
            
        }
    }
    
    @IBOutlet weak var packagesTableView: UITableView!
    @IBOutlet weak var ourPackagesView: UIView!
    @IBOutlet weak var ourPackagesBtnOutlet: UIButton!
    
    var sliders : [Slider] = []
    
    
    var foodSystems : [FoodSystemItem] = []

    var imageURL = ""
    var sliderURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSlider()
        
        Messaging.messaging().subscribe(toTopic: "all") { error in
            print("Subscribed to all topic")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        getPackages()
        
        getFoodSystems()
        
    }
    
    @IBAction func ourPackagesBtnAction(_ sender: Any) {
    }
    
    //MARK: Api

    
    
    func getFoodSystems() {
        self.view.makeToastActivity(.center)
        
        Connect.default.request(MainConnector.foodSystems).decoded(toType: FoodSystemModel.self).observe {
            (result) in
            
            self.view.hideToastActivity()
            
            switch result {
                
            case .success(let data):
                print("foodSystems success")
                self.foodSystems = data.result ?? []
                print(self.foodSystems, "should be food system")
//                self.imageURL = data.result?.image_url ?? ""
//                DispatchQueue.main.async {
                    self.packagesTableView.reloadData()
                    //                    self.pagerView.reloadData()
//                }
                
            case .failure(let error):
                print("foodSystems failed")
                self.view.makeToast(error.localizedDescription)
            }
            
        }
    }

    
    func getSlider() {
        self.view.makeToastActivity(.center)
        Connect.default.request(MainConnector.getSlider).decoded(toType: SliderResponse.self).observe { (result) in
            self.view.hideToastActivity()
            switch result {
                
            case .success(let data):
                print("slider success")
                self.sliders = data.result?.sliders ?? []
                self.sliderURL = data.result?.image_url ?? ""
                DispatchQueue.main.async {
                    self.pagerView.reloadData()
                }
            case .failure(let error):
                print("slider failed")
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    
    fileprivate func setupSideMenu() {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SideMenuItemsVC")
        var setting = SideMenuSettings()
        setting.presentationStyle = .menuSlideIn
        setting.menuWidth = UIScreen.main.bounds.size.width * 0.8
        
        let sideMenuManager = SideMenuNavigationController(rootViewController: vc!, settings: setting)
        sideMenuManager.statusBarEndAlpha = 0
        sideMenuManager.navigationBar.isHidden = true
        sideMenuManager.leftSide = Helper.isEnglish()
        present(sideMenuManager, animated: true, completion: nil)
    }
    
    @IBAction func menuButton(_ sender: Any) {
        setupSideMenu()
    }
    
    
}

//MARK: Table

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodSystems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell
        
        let title = Helper.language == "ar" ? foodSystems[indexPath.row].nameAr : foodSystems[indexPath.row].nameEn
        cell.titleLbl.text = title

        cell.moreBtnOutlet.onTap { [weak self] in
//
            let vc = self!.pushToSignUp()
            
            self?.present(vc, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func pushToSignUp()->ShowPackagesVC{
        let vc = self.storyboard!.instantiateViewController(identifier: "ShowPackagesVC") as! ShowPackagesVC

        vc.chosePackageNowPushSignup = { [weak self] showPackagesVC, planId in
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
            vc.planId = planId
            
            showPackagesVC.dismiss(animated: true)


            self?.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        return vc

    }
}

//MARK: SLider
extension MainVC :  FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return sliders.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {

        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        var imgURL = ""
        if sliders.count == 1 {
            imgURL = "\(sliderURL)/\(sliders.first?.image ?? "")"
        }else {
            imgURL = "\(sliderURL)/\(sliders[index].image ?? "")"
        }
        if let url = URL(string: imgURL) {
            cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage.init(named: "logo"))
            //        cell.imageView?.kf.setImage(with: url)
            
        }
        
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
}




extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
