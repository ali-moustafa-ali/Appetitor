//
//  SportsTargetVC.swift
//  Dietness
//
//  Created by Ahmad medo on 08/09/2023.
//  Copyright © 2023 Dietness. All rights reserved.
//

import UIKit

class SportsTargetVC: UIViewController {

    @IBOutlet weak var sportsTargetTable: UITableView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLbl.text = "Sports Target".localized
        
    }


}
//MARK: Table for packages

extension SportsTargetVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportsTargetCell", for: indexPath) as! SportsTargetCell

//        let imgURL = "\(imageURL)/\(packages[indexPath.row].image ?? "")"
//
//        if let url = URL(string: imgURL) {
//            cell.packageImage.sd_setImage(with: url, placeholderImage: UIImage.init(named: "default"))
//        }
//
//        cell.moreBtnOutlet.onTap { [weak self] in
//
//            let vc = self?.storyboard?.instantiateViewController(identifier: "PackagePopUpVC") as! PackagePopUpVC
//
//            vc.package = self?.packages[indexPath.row]
//            vc.imageURL = imgURL
//
//            //
//            vc.didTapSubscribe = {[weak self] planId in
//                guard let self = self else{return}
//
//                self.chosePackageNowPushSignup!(self , planId)
//
//            }
//
//            self?.present(vc, animated: true, completion: nil)
//        }

        return cell
    }


}

class SportsTargetCell: UITableViewCell {

    
    @IBOutlet weak var packageImage: UIImageView!
    @IBOutlet weak var moreBtnOutlet: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



}
