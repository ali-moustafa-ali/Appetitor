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
    var packages : [Package] = []
    var imageURL = ""
    var sliderURL = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        getSlider()
        Messaging.messaging().subscribe(toTopic: "all") { error in
          print("Subscribed to all topic")
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getPackages()
        
    }
    
    @IBAction func ourPackagesBtnAction(_ sender: Any) {
    }
    func getPackages() {
        self.view.makeToastActivity(.center)
        Connect.default.request(MainConnector.getPackages).decoded(toType: PackagesResponse.self).observe { (result) in
            self.view.hideToastActivity()
            switch result {
                
            case .success(let data):
                print("packages success")
                self.packages = data.result?.packages ?? []
                print(self.packages)
                self.imageURL = data.result?.image_url ?? ""
                DispatchQueue.main.async {
                    self.packagesTableView.reloadData()
//                    self.pagerView.reloadData()
                }
            case .failure(let error):
                print("packages failed")
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
extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return packages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell
       
        let imgURL = "\(imageURL)/\(packages[indexPath.row].image ?? "")"
        if let url = URL(string: imgURL) {
                    cell.packageImage.sd_setImage(with: url, placeholderImage: UIImage.init(named: "default"))
        }
        cell.moreBtnOutlet.onTap { [weak self] in
                   let vc = self?.storyboard?.instantiateViewController(identifier: "PackagePopUpVC") as! PackagePopUpVC
                   vc.package = self?.packages[indexPath.row]
            vc.imageURL = imgURL
            vc.didTapSubscribe = {[weak self] in
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            self?.present(vc, animated: true, completion: nil)
               }
        return cell
    }
    
    
}
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
        
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.clipsToBounds = true
           return cell
    }
}
